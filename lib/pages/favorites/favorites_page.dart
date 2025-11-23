import 'package:flutter/material.dart';
import 'package:locai/widgets/place_card.dart';
import 'package:locai/state/favorites_state.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String _selectedSort = "Rating";

  List<Place> _sortFavorites(List<Place> list) {
    final sorted = List<Place>.from(list);

    if (_selectedSort == "Rating") {
      sorted.sort((a, b) => b.rating.compareTo(a.rating)); // High → Low
    } else if (_selectedSort == "Name") {
      sorted.sort((a, b) => a.name.compareTo(b.name)); // A → Z
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Place>>(
      valueListenable: FavoritesState.instance.favorites,
      builder: (context, favorites, _) {
        final sortedFavorites = _sortFavorites(favorites);

        return ListView(
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
              style: const TextStyle(color: Colors.black45),
            ),

            const SizedBox(height: 16),

            if (sortedFavorites.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.favorite_border,
                        size: 72,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the heart icon on a place\non the Home tab to save it here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              for (int i = 0; i < sortedFavorites.length; i++)
                PlaceCard(
                  place: sortedFavorites[i],
                  isInitiallyFavorite: true,
                  onFavoriteChanged: (isFavorite) {
                    if (!isFavorite) {
                      FavoritesState.instance
                          .setFavorite(sortedFavorites[i], false);
                    }
                  },
                ),
          ],
        );
      },
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Sort by',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        const SizedBox(width: 10),

        DropdownButton<String>(
          value: selectedSort,
          items: const [
            DropdownMenuItem(
              value: "Rating",
              child: Text("Rating"),
            ),
            DropdownMenuItem(
              value: "Name",
              child: Text("Name"),
            ),
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
