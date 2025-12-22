import 'package:flutter/material.dart';
import 'package:locai/widgets/place_card.dart';
import 'package:locai/utils/text_styles.dart';

class PlaceDetailsPage extends StatelessWidget {
  const PlaceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final place = args is Place
        ? args
        : const Place(
      name: 'Unknown Place',
      rating: 0.0,
      description: 'No description available.',
      imageUrl:
      'https://via.placeholder.com/600x300.png?text=No+Image',
    );

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.onSurface),
        title: Text(
          place.name,
          style: AppTextStyles.subheading.copyWith(
            color: colors.onSurface,
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 30),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Create Route',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    place.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color:
                          Theme.of(context).shadowColor.withOpacity(0.12),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // AI Summary header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'AI Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Summary box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Here are some key points:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _BulletText('Customer favourite: Bento with sashimi'),
                    _BulletText('Atmosphere: Calm and cozy'),
                    _BulletText('Accessibility: Wheelchair accessible'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // General Information heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'General Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Opening hours
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Opening Hours: 11.00 – 21.00',
                style: TextStyle(
                  fontSize: 13,
                  color: colors.onSurface.withOpacity(0.75),
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: colors.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: colors.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
