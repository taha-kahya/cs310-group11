import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceReviewsService {
  static const String _apiKey = 'Enter Google Places API key here.';

  /// Fetch reviews for a place using place ID
  static Future<List<Map<String, dynamic>>> getReviews(String placeId) async {
    final url = 'https://places.googleapis.com/v1/places/$placeId';

    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask': 'reviews',
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch reviews: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final reviews = data['reviews'] as List<dynamic>?;

      if (reviews == null || reviews.isEmpty) {
        return [];
      }

      // Return the reviews as a list of maps
      return reviews.map((review) => review as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  /// Get the last N reviews
  static Future<List<Map<String, dynamic>>> getLastNReviews(
      String placeId, {
        int count = 5,
      }) async {
    final allReviews = await getReviews(placeId);

    // Sort by time (most recent first) if publishTime exists
    allReviews.sort((a, b) {
      final timeA = a['publishTime'] as String?;
      final timeB = b['publishTime'] as String?;

      if (timeA == null || timeB == null) return 0;
      return timeB.compareTo(timeA);
    });

    // Return only the last N reviews
    return allReviews.take(count).toList();
  }

  /// Format reviews into text for AI summarization
  static String formatReviewsForSummary(List<Map<String, dynamic>> reviews) {
    final buffer = StringBuffer();

    for (var i = 0; i < reviews.length; i++) {
      final review = reviews[i];
      final text = review['text']?['text'] ?? review['originalText']?['text'] ?? '';
      final rating = review['rating'] ?? 0;

      buffer.writeln('Review ${i + 1} (Rating: $rating/5):');
      buffer.writeln(text);
      buffer.writeln();
    }

    return buffer.toString();
  }
}