import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    // Dışarıdaki MainShell zaten Scaffold + AppBar + BottomNav veriyor,
    // o yüzden burada SADECE içerik var.
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      children: const [
        _SortRow(),
        SizedBox(height: 6),
        Text(
          '3 favorites',
          style: TextStyle(color: Colors.black45),
        ),
        SizedBox(height: 16),

        // 3 tane kart (assets/images içindeki fotolar kullanılıyor)
        FavoriteItemCard(
          imagePath: 'assets/images/temp_image_1.jpg',
          rating: 4.9,
          title: 'SushiCo',
          description:
          'Sushico – Fresh Asian fusion with sushi, noodles, and bold flavors served in a modern, cozy setting.',
        ),
        SizedBox(height: 14),
        FavoriteItemCard(
          imagePath: 'assets/images/temp_image_2.jpg',
          rating: 4.9,
          title: 'RamenToGo',
          description:
          'RamenToGo – Quick, fresh, and flavorful ramen made for comfort on the go.',
        ),
        SizedBox(height: 14),
        FavoriteItemCard(
          imagePath: 'assets/images/temp_image_3.jpg',
          rating: 4.6,
          title: 'Japanese Fried Chicken',
          description:
          'Japanese Fried Chicken – Crispy, juicy, and flavorful bites served in a comfy, quiet place with convenient charging outlets.',
        ),
      ],
    );
  }
}

// --------- "Sort by  Rating ▼" satırı ----------
class _SortRow extends StatelessWidget {
  const _SortRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'Sort by',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        SizedBox(width: 10),
        Text(
          'Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Icon(Icons.keyboard_arrow_down),
      ],
    );
  }
}

// --------- Kart widget'ı ----------
class FavoriteItemCard extends StatelessWidget {
  final String imagePath;
  final double rating;
  final String title;
  final String description;

  const FavoriteItemCard({
    super.key,
    required this.imagePath,
    required this.rating,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sol taraf: foto + rating rozeti
          Padding(
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    imagePath,
                    width: 120,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sağ taraf: başlık + açıklama
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.only(right: 8, top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sağ uç: kalp
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

