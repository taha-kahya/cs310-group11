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

import 'package:locai/services/places_text_search_service.dart';
import 'package:locai/services/place_photo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  void _applySorting() {
    if (_selectedSort == 'Rating') {
      _filteredPlaces.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_selectedSort == 'Distance') {
      return;
    }
  }

  Future<void> _searchPlacesFromApi(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredPlaces = List.from(_allPlaces);
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiResults = await PlacesTextSearchService.search(
        query: query,
      );

      final List<Place> places = [];

      for (final item in apiResults) {
        final displayName = item['displayName']?['text'] ?? 'Unknown';
        final address = item['formattedAddress'] ?? '';
        final rating = (item['rating'] ?? 0).toDouble();

        String imageUrl = 'assets/images/temp_image_1.jpg';

        final photos = item['photos'];
        if (photos != null && photos.isNotEmpty) {
          final photoName = photos.first['name'];
          if (photoName != null) {
            imageUrl = PlacePhotoService.getPhotoUrlDirect(
              photoName,
              maxWidth: 400,
              maxHeight: 400,
            );
          }
        }

        final placeId = item['id'] ?? '';

        places.add(
          Place(
            name: displayName,
            rating: rating,
            description: address,
            imageUrl: imageUrl,
            placeId: placeId,
          ),
        );
      }

      if (places.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoPlacesFoundPage(query: query),
          ),
        );
      }

      setState(() {
        _filteredPlaces = places;
        _applySorting();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Places API error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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

    _allPlaces = const [];
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

  void _onSearchChanged(String value) async {
    final query = value.toLowerCase();
    List<Place> results;

    if (query.isEmpty) {
      results = List.from(_allPlaces);
    } else {
      results = _allPlaces
          .where((place) => place.name.toLowerCase().contains(query))
          .toList();

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

    }

    setState(() {
      _filteredPlaces = results;
      _applySorting();
    });
  }

  void _onSearchChangedDebounced(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _searchPlacesFromApi(value);
      _onSearchChanged(value);
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Start Your Search',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Results will appear once you search for a place',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        _searchPlacesFromApi(providerQuery);
        _onSearchChanged(providerQuery);
        searchProvider.clear();
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
                  borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : const Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : const Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ),
          if (_filteredPlaces.isNotEmpty) ...[
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
                        _applySorting();
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
          ],
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredPlaces.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];
                final placeId = place.name;
                final isFav =
                favProvider.isFavorite(placeId);

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
