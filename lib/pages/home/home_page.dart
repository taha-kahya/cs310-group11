import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locai/providers/auth_provider.dart';

import 'package:locai/widgets/place_card.dart';
import 'package:locai/utils/text_styles.dart';
import 'package:locai/pages/noPlacesFound/no_places_found_page.dart';

import 'package:locai/providers/favorites_provider.dart';
import 'package:locai/providers/search_provider.dart';

import 'package:locai/models/favorite_place.dart';
import 'package:locai/models/search_history.dart';
import 'package:locai/repositories/recent_searches_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Place> _allPlaces;
  late List<Place> _filteredPlaces;

  String _selectedSort = 'Relevance';
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;
  final RecentSearchesRepository _searchRepo = RecentSearchesRepository();
  String? _lastSavedQuery;

  @override
  void initState() {
    super.initState();

    _allPlaces = const [
      Place(
        name: 'Sushico',
        rating: 4.9,
        description:
        'Fresh Asian fusion with sushi, noodles, and bold flavors served in a modern, cozy setting.',
        imageUrl: "assets/images/temp_image_1.jpg",
      ),
      Place(
        name: 'RamenToGo',
        rating: 4.9,
        description:
        'Quick, fresh, and flavorful ramen made for comfort on the go.',
        imageUrl: "assets/images/temp_image_2.jpg",
      ),
      Place(
        name: 'Japanese Fried Chicken',
        rating: 4.6,
        description:
        'Crispy, juicy bites served in a comfy, quiet place with convenient charging outlets.',
        imageUrl: "assets/images/temp_image_3.jpg",
      ),
    ];

    _filteredPlaces = List.from(_allPlaces);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<FavoritesProvider>().start(user.uid);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ---------------- SEARCH LOGIC ----------------

  void _onSearchChanged(String value) async {
    final query = value.toLowerCase();
    List<Place> results;

    if (query.isEmpty) {
      results = List.from(_allPlaces);
    } else {
      results = _allPlaces
          .where((place) => place.name.toLowerCase().contains(query))
          .toList();

      // Save to recent searches (avoid duplicates)
      final trimmed = value.trim();
      if (trimmed.isNotEmpty && trimmed != _lastSavedQuery) {
        _lastSavedQuery = trimmed;
        final user = context.read<AuthProvider>().currentUser;
        if (user != null) {
          await _searchRepo.addSearch(
            SearchHistory(
              id: '',
              query: trimmed,
              createdBy: user.uid,
              createdAt: DateTime.now(),
            ),
          );
        }
      }

      if (results.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoPlacesFoundPage(query: value),
          ),
        );
      }
    }

    setState(() {
      _filteredPlaces = results;
    });
  }

  void _onSearchChangedDebounced(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _onSearchChanged(value);
    });
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final authProvider = context.watch<AuthProvider>();
    final uid = authProvider.currentUser!.uid;

    final searchProvider = context.watch<SearchProvider>();
    final providerQuery = searchProvider.query;

    if (providerQuery != null && providerQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchController.text = providerQuery;
        _onSearchChanged(providerQuery);
        searchProvider.clear(); // consume once
      });
    }

    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF7F7F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.body,
              onChanged: _onSearchChangedDebounced,
              decoration: InputDecoration(
                hintText: 'Search for the place in your mind',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                  BorderSide(color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade700
                      : const Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                  BorderSide(color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade700
                      : const Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: [
                const Text('Sort by', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedSort,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                        value: 'Relevance', child: Text('Relevance')),
                    DropdownMenuItem(value: 'Rating', child: Text('Rating')),
                    DropdownMenuItem(
                        value: 'Distance', child: Text('Distance')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedSort = value);
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Found ${_filteredPlaces.length} results',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];
                final placeId = place.name;
                final isFav = favProvider.isFavorite(placeId);

                return PlaceCard(
                  key: ValueKey(placeId),
                  place: place,
                  isInitiallyFavorite: isFav,
                  onFavoriteChanged: (isFavorite) async {
                    if (isFavorite) {
                      await favProvider.toggleFavorite(
                        uid: uid,
                        placeId: placeId,
                        fav: FavoritePlace(
                          id: '',
                          placeId: placeId,
                          name: place.name,
                          rating: place.rating,
                          address: '',
                          imageUrl: place.imageUrl,
                          preview: place.description,
                          createdBy: uid,
                          createdAt: DateTime.now(),
                        ),
                        makeFavorite: true,
                      );
                    } else {
                      await favProvider.toggleFavorite(
                        uid: uid,
                        placeId: placeId,
                        fav: null,
                        makeFavorite: false,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
