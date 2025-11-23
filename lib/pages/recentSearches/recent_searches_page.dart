import 'package:flutter/material.dart';
import 'package:locai/widgets/place_card.dart';
import 'package:locai/widgets/custom_app_bar.dart';

class RecentPlace {
  final Place place;
  final DateTime createdAt;

  const RecentPlace({
    required this.place,
    required this.createdAt,
  });
}

class RecentSearchesPage extends StatefulWidget {
  const RecentSearchesPage({super.key});

  @override
  State<RecentSearchesPage> createState() => _RecentSearchesPageState();
}

class _RecentSearchesPageState extends State<RecentSearchesPage> {
  final List<RecentPlace> _allPlaces = [
    RecentPlace(
      place: const Place(
        name: 'SushiCo',
        rating: 4.7,
        description:
        'SushiCo - Fresh Asian fusion with sushi, noodles and bold flavors served in a modern, cozy setting.',
        imageUrl: "assets/images/temp_image_1.jpg",
      ),
      createdAt: DateTime.now(),
    ),
    RecentPlace(
      place: const Place(
        name: 'RamenToGo',
        rating: 4.3,
        description:
        'RamenToGo - Quick, fresh, and flavorful ramen made for comfort on the go.',
        imageUrl: "assets/images/temp_image_2.jpg",
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RecentPlace(
      place: const Place(
        name: 'Japanese Fried Chicken',
        rating: 4.8,
        description:
        'Japanese Fried Chicken - Crispy, juicy, and flavorful bites served in a comfy, quiet place with convenient charging outlets.',
        imageUrl: "assets/images/temp_image_3.jpg",
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<RecentPlace> _filtered = [];
  String _sortBy = 'Newest';
  int _currentPage = 0;
  final int _perPage = 3;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    List<RecentPlace> tmp = List.from(_allPlaces);

    if (_sortBy == 'Newest') {
      tmp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'Highest Rated') {
      tmp.sort((a, b) => b.place.rating.compareTo(a.place.rating));
    }

    setState(() {
      _filtered = tmp;
      _currentPage = 0;
    });
  }

  void _deletePlace(RecentPlace rp) {
    setState(() {
      _allPlaces.remove(rp);
    });
    _applyFilters();
  }

  int get _pageCount =>
      _filtered.isEmpty ? 0 : (_filtered.length / _perPage).ceil();

  List<RecentPlace> get _pageItems {
    final start = _currentPage * _perPage;
    final end = start + _perPage;
    return _filtered.sublist(
      start,
      end > _filtered.length ? _filtered.length : end,
    );
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _pageCount) return;
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Recent Searches',
        showBack: true,
        showMenu: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: const InputDecoration(labelText: 'Sort by'),
                    items: ['Newest', 'Highest Rated']
                        .map(
                          (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ),
                    )
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      _sortBy = val;
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Page content
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('No results.'))
                  : ListView.builder(
                itemCount: _pageItems.length,
                itemBuilder: (context, idx) {
                  final recent = _pageItems[idx];

                  return PlaceCard(
                    place: recent.place,
                    onDelete: () => _deletePlace(recent),
                  );
                },
              ),
            ),

            // Pagination
            if (_pageCount > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _currentPage > 0
                        ? () => _goToPage(_currentPage - 1)
                        : null,
                    child: const Text('Prev'),
                  ),
                  for (int i = 0; i < _pageCount; i++)
                    TextButton(
                      onPressed: () => _goToPage(i),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontWeight: i == _currentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  TextButton(
                    onPressed: _currentPage < _pageCount - 1
                        ? () => _goToPage(_currentPage + 1)
                        : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
