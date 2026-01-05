import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesTextSearchService {
  static const String _endpoint =
      'https://places.googleapis.com/v1/places:searchText';

  // TEMPORARY for course project
  static const String _apiKey = 'AIzaSyBfnTlli4YB1Y0t_duse8d0gmzwjDp3A2k';

  static Future<List<Map<String, dynamic>>> search({
    required String query,
    double? latitude,
    double? longitude,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask':
      'places.id,places.displayName,places.formattedAddress,places.location',
    };

    final body = {
      'textQuery': query,
      if (latitude != null && longitude != null)
        'locationBias': {
          'circle': {
            'center': {
              'latitude': latitude,
              'longitude': longitude,
            },
            'radius': 5000.0,
          }
        }
    };

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Places API error: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(data['places'] ?? []);
  }
}
