import 'package:flutter/material.dart';

class Place {
  final String name;
  final double rating;
  final String description;
  final String imageUrl;

  const Place({
    required this.name,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });
}

class PlaceCard extends StatefulWidget {
  final Place place;
  final VoidCallback? onDelete;

  /// Whether this place starts as favorite in the UI
  final bool isInitiallyFavorite;

  /// Called whenever the heart is toggled (true = favorite, false = not)
  final ValueChanged<bool>? onFavoriteChanged;

  const PlaceCard({
    super.key,
    required this.place,
    this.onDelete,
    this.isInitiallyFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  bool _isFavorite = false; // UI only

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isInitiallyFavorite;
  }

  @override
  void didUpdateWidget(covariant PlaceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInitiallyFavorite != widget.isInitiallyFavorite) {
      _isFavorite = widget.isInitiallyFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return InkWell(
      // Open details page with this place
      onTap: () {
        Navigator.pushNamed(
          context,
          '/place-details',
          arguments: place,
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  place.imageUrl,
                  width: 115,
                  height: 115,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),

              // Text + rating + heart (+ optional delete)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: Name + optional delete icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (widget.onDelete != null) ...[
                          const SizedBox(width: 4),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.grey,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: widget.onDelete,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Description
                    Text(
                      place.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Bottom row: rating + favorite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.orangeAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              place.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // Heart icon (just visual toggle)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                            widget.onFavoriteChanged?.call(_isFavorite);
                          },
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(_isFavorite),
                              color: Colors.redAccent,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
