import 'package:flutter/material.dart';
import 'package:locai/widgets/place_card.dart';
import 'package:locai/utils/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Place> _places;
  String _selectedSort = 'Relevance';

  @override
  void initState() {
    super.initState();
    _places = [
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
        imageUrl: "assets/images/temp_image_2.jpg"
      ),
      const Place(
        name: 'Japanese Fried Chicken',
        rating: 4.6,
        description:
        'Crispy, juicy bites served in a comfy, quiet place with convenient charging outlets.',
        imageUrl: "assets/images/temp_image_3.jpg",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F7F7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Search for the place in your mind',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                  const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                  const BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
            ),
          ),

          // Sort bar
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Row(
              children: [
                const Text('Sort by',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedSort,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                        value: 'Relevance', child: Text('Relevance')),
                    DropdownMenuItem(
                        value: 'Rating', child: Text('Rating')),
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

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Found ${_places.length} results',
              style: const TextStyle(
                  fontSize: 13, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 8),

          // List of cards
          Expanded(
            child: ListView.builder(
              padding:
              const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return PlaceCard(
                  place: place,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
