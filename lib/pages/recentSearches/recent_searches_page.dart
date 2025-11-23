import 'package:flutter/material.dart';

// Model
class Place {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  int rating; // 1..5
  bool favorite;

  Place({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    this.rating = 0,
    this.favorite = false,
  });
}

class RecentSearchesPage extends StatefulWidget {
  const RecentSearchesPage({super.key});

  @override
  State<RecentSearchesPage> createState() => _RecentSearchesPageState();
}

class _RecentSearchesPageState extends State<RecentSearchesPage> {

  final List<Place> _allPlaces = [
    Place(
      id: 'p1',
      title: 'SushiCo',
      description: 'SushiCo - Fresh Asian fusion with sushi, noodles and bold flavors served in a modern, cozy setting.',
      imageUrl: 'assets/images/temp_image_1.jpg',
      createdAt: DateTime.now(),
    ),
    Place(
      id: 'p2',
      title: 'RamenToGo',
      description: 'RamenToGo - Quick, fresh, and flavorful ramen made for comfort on the go.',
      imageUrl: 'assets/images/temp_image_2.jpg',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Place(
      id: 'p3',
      title: 'Japanese Fried Chicken',
      description: 'Japanese Fried Chicken- Crispy, juicy, and flavorful bites served in a comfy, quiet place with convenient charging outlets.',
      imageUrl: 'assets/images/temp_image_3.jpg',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),


  ];

  List<Place> _filtered = [];
  String _sortBy = 'Newest';
  int _currentPage = 0;
  final int _perPage = 3;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    List<Place> tmp = List.from(_allPlaces);

    // sort
    if (_sortBy == 'Newest') {
      tmp.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_sortBy == 'Highest Rated') {
      tmp.sort((a, b) => b.rating.compareTo(a.rating));
    }

    setState(() {
      _filtered = tmp;
      _currentPage = 0;
    });
  }

  void _toggleFavorite(Place p) {
    setState(() {
      p.favorite = !p.favorite;
    });
  }

  void _setRating(Place p, int stars) {
    setState(() {
      p.rating = stars;
    });
    _applyFilters();
  }

  int get _pageCount => (_filtered.length / _perPage).ceil();

  List<Place> get _pageItems {
    final start = _currentPage * _perPage;
    final end = start + _perPage;
    return _filtered.sublist(start, end > _filtered.length ? _filtered.length : end);
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
      appBar: AppBar(
        title: const Text('Recent Searches'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Sort dropdown
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _sortBy,
                    decoration: const InputDecoration(labelText: 'Sort by'),
                    items: ['Newest', 'Highest Rated']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
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
                  final place = _pageItems[idx];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // Resim
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              place.imageUrl,
                              width: 120,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Başlık ve açıklama
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.title,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  place.description,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                                const SizedBox(height: 6),
                                // Star rating
                                Row(
                                  children: List.generate(5, (i) {
                                    final starIndex = i + 1;
                                    return IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: Icon(
                                        starIndex <= place.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      onPressed: () => _setRating(place, starIndex),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          // Favorite button
                          IconButton(
                            icon: Icon(
                              place.favorite ? Icons.favorite : Icons.favorite_border,
                              color: place.favorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(place),
                          ),
                        ],
                      ),
                    ),
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
                      onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
                      child: const Text('Prev')),
                  for (int i = 0; i < _pageCount; i++)
                    TextButton(
                      onPressed: () => _goToPage(i),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                            fontWeight: i == _currentPage ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  TextButton(
                      onPressed:
                      _currentPage < _pageCount - 1 ? () => _goToPage(_currentPage + 1) : null,
                      child: const Text('Next')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}