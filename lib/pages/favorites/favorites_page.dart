import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locai/widgets/place_card.dart';
import 'package:locai/models/favorite_place.dart';
import 'package:locai/providers/favorites_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String _selectedSort = "Rating";

  Place _toPlace(FavoritePlace fav) {
    return Place(
      name: fav.name,
      rating: fav.rating,
      description: fav.preview,
      imageUrl: fav.imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final favorites = favProvider.favorites;

    final sortedFavorites = List<FavoritePlace>.from(favorites)
      ..sort((a, b) {
        if (_selectedSort == "Rating") {
          return b.rating.compareTo(a.rating);
        } else {
          return a.name.compareTo(b.name);
        }
      });

    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF7F7F7),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        children: [
          _SortRow(
            selectedSort: _selectedSort,
            onSortChanged: (value) {
              setState(() {
                _selectedSort = value;
              });
            },
          ),
          const SizedBox(height: 6),
          Text(
            '${sortedFavorites.length} favorites',
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6)),
          ),
          const SizedBox(height: 16),
          if (sortedFavorites.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 72, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No favorites yet',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on a place\non the Home tab to save it here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            for (final fav in sortedFavorites)
              PlaceCard(
                key: ValueKey(fav.placeId),
                place: _toPlace(fav),
                isInitiallyFavorite: true,
                onFavoriteChanged: (isFavorite) async {
                  if (!isFavorite) {
                    // Remove from favorites
                    await favProvider.toggleFavorite(
                      uid: uid,
                      placeId: fav.placeId,
                      fav: null,
                      makeFavorite: false,
                    );
                  }
                },
              ),
        ],
      ),
    );
  }
}

class _SortRow extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSortChanged;

  const _SortRow({
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Sort by', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedSort,
          items: const [
            DropdownMenuItem(value: "Rating", child: Text("Rating")),
            DropdownMenuItem(value: "Name", child: Text("Name")),
          ],
          underline: const SizedBox(),
          onChanged: (value) {
            if (value != null) onSortChanged(value);
          },
        ),
      ],
    );
  }
}