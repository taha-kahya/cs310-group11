import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:locai/widgets/place_card.dart';
import 'package:locai/utils/text_styles.dart';
import 'package:locai/pages/noPlacesFound/no_places_found_page.dart';
import 'package:locai/providers/favorites_provider.dart';
import 'package:locai/models/favorite_place.dart';

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
  bool _hasAppliedInitialSuggestion = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    _allPlaces = [
      const Place(
        name: 'Sushico',
        rating: 4.9,
        description:
        'Fresh Asian fusion with sushi, noodles, and bold flavors served in a modern, cozy setting.',
        imageUrl: "assets/images/temp_image_1.jpg",
      ),
      const Place(
        name: 'RamenToGo',
        rating: 4.9,
        description:
        'Quick, fresh, and flavorful ramen made for comfort on the go.',
        imageUrl: "assets/images/temp_image_2.jpg",
      ),
      const Place(
        name: 'Japanese Fried Chicken',
        rating: 4.6,
        description:
        'Crispy, juicy bites served in a comfy, quiet place with convenient charging outlets.',
        imageUrl: "assets/images/temp_image_3.jpg",
      ),
    ];

    _filteredPlaces = List.from(_allPlaces);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
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

  void _onSearchChanged(String value) {
    final query = value.toLowerCase();
    List<Place> results;

    if (query.isEmpty) {
      results = List.from(_allPlaces);
    } else {
      results = _allPlaces
          .where((place) => place.name.toLowerCase().contains(query))
          .toList();

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

  @override
  Widget build(BuildContext context) {
    final suggestion = ModalRoute.of(context)?.settings.arguments as String?;
    final favProvider = context.watch<FavoritesProvider>();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (suggestion != null &&
        suggestion.isNotEmpty &&
        !_hasAppliedInitialSuggestion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchController.text = suggestion;
        _onSearchChanged(suggestion);
        _hasAppliedInitialSuggestion = true;
      });
    }

    return Container(
      color: const Color(0xFFF7F7F7),
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
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
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
                    setState(() {
                      _selectedSort = value;
                    });
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

                // Watch the favorite status from provider
                final isFav = favProvider.isFavorite(placeId);

                return PlaceCard(
                  key: ValueKey(placeId),
                  place: place,
                  isInitiallyFavorite: isFav,
                  onFavoriteChanged: (isFavorite) async {
                    if (isFavorite) {
                      // Adding to favorites
                      final fav = FavoritePlace(
                        id: '',
                        placeId: placeId,
                        name: place.name,
                        rating: place.rating,
                        address: '',
                        imageUrl: place.imageUrl,
                        preview: place.description,
                        createdBy: uid,
                        createdAt: DateTime.now(),
                      );

                      await favProvider.toggleFavorite(
                        uid: uid,
                        placeId: placeId,
                        fav: fav,
                        makeFavorite: true,
                      );
                    } else {
                      // Removing from favorites
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