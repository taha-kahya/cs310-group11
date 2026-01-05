import 'package:flutter/material.dart';
import 'package:locai/widgets/place_card.dart';
import 'package:locai/utils/text_styles.dart';
import 'package:locai/services/place_reviews_service.dart';
import 'package:locai/services/ai_summary_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsPage extends StatefulWidget {
  const PlaceDetailsPage({super.key});

  @override
  State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  Map<String, dynamic>? _aiSummary;
  bool _isLoadingSummary = true;
  String? _error;
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _hasLoaded = true;
      _loadAISummary();
    }
  }

  Future<void> _loadAISummary() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! Place) {
      setState(() {
        _isLoadingSummary = false;
        _error = 'Invalid place data';
      });
      return;
    }

    final place = args;

    if (place.placeId.isEmpty) {
      setState(() {
        _isLoadingSummary = false;
        _error = 'No place ID available';
      });
      return;
    }

    try {
      final reviews = await PlaceReviewsService.getLastNReviews(
        place.placeId,
        count: 5,
      );

      if (reviews.isEmpty) {
        setState(() {
          _isLoadingSummary = false;
          _error = 'No reviews available';
        });
        return;
      }

      final reviewsText =
      PlaceReviewsService.formatReviewsForSummary(reviews);

      final summary =
      await AISummaryService.summarizeReviews(reviewsText);

      setState(() {
        _aiSummary = summary;
        _isLoadingSummary = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSummary = false;
        _error = 'Failed to load summary';
      });
      debugPrint('Error loading AI summary: $e');
    }
  }

  Future<void> _openRoute(String placeName) async {
    final encoded = Uri.encodeComponent(placeName);
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$encoded');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
            onPressed: () => _openRoute(place.name),
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
                          color: Theme.of(context)
                              .shadowColor
                              .withOpacity(0.12),
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
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.primary,
                          colors.primary.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome,
                            size: 14, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'AI Summary',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.surface,
                      colors.surface.withOpacity(0.95),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                      color:
                      Theme.of(context).shadowColor.withOpacity(0.08),
                    ),
                  ],
                ),
                child: _buildSummaryContent(colors),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryContent(ColorScheme colors) {
    if (_isLoadingSummary) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null || _aiSummary == null) {
      return Column(
        children: [
          Icon(Icons.info_outline,
              color: colors.onSurface.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unable to generate summary',
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    final favoriteItem = _aiSummary!['favorite_item'] as String? ?? '';
    final atmosphere = _aiSummary!['atmosphere'] as String? ?? '';
    final accessibility = _aiSummary!['accessibility'] as String? ?? '';
    final highlights = _aiSummary!['highlights'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Based on recent reviews',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 14),
        if (favoriteItem.isNotEmpty)
          _BulletText('Customer favourite: $favoriteItem'),
        if (atmosphere.isNotEmpty)
          _BulletText('Atmosphere: $atmosphere'),
        if (accessibility.isNotEmpty)
          _BulletText('Accessibility: $accessibility'),
        if (highlights.isNotEmpty)
          ...highlights.map((h) => _BulletText(h.toString())),
      ],
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.5,
                color: colors.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
