import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacePhotoService {
  static const String _apiKey = 'Enter Google Places API key here.';

  /// Get photo URL directly - returns the media URL that can be used in Image.network()
  /// photoName format: "places/{place_id}/photos/{photo_reference}"
  static String getPhotoUrlDirect(
      String photoName, {
        int maxWidth = 400,
        int maxHeight = 400,
      }) {
    return 'https://places.googleapis.com/v1/$photoName/media'
        '?key=$_apiKey'
        '&maxHeightPx=$maxHeight'
        '&maxWidthPx=$maxWidth';
  }

  /// Legacy method - now just returns the direct URL
  static Future<String?> getPhotoUrl(String photoName) async {
    return getPhotoUrlDirect(photoName);
  }
}
