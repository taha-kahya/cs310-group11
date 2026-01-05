import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacePhotoService {
  static const String _apiKey = 'YOUR_PLACES_API_KEY_HERE';

  static Future<String?> getPhotoUrl(String photoName) async {
    final url =
        'https://places.googleapis.com/v1/$photoName/media'
        '?maxHeightPx=400&key=$_apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);
    return data['photoUri'];
  }
}
