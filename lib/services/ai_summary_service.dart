import 'dart:convert';
import 'package:http/http.dart' as http;

class AISummaryService {
  static const String _apiKey = 'Enter Gemini API key here.';
  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent';

  static Future<Map<String, dynamic>> summarizeReviews(String reviewsText) async {
    if (reviewsText.trim().isEmpty) {
      return _fallback();
    }

    final uri = Uri.parse('$_endpoint?key=$_apiKey');

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text': '''
Summarize the following restaurant reviews.
USE ONLY MAXIMUM 3 WORDS FOR EACH description
IF THE OUTPUT IS ABOUT TO PASS 3000 MAX TOKENS JUST CUT THE PART
THAT MAKES THE OUTPUT NOT FINISHED AND FINISH THE OUTPUT IN THE GIVEN FORMAT.

Respond ONLY with JSON in this exact format:

{
  "favorite_item": "",
  "atmosphere": "",
  "accessibility": "",
  "highlights": []
}

Reviews:
$reviewsText
'''
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.1,
        'maxOutputTokens': 3000
      }
    });

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Gemini API error ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final rawText =
      data['candidates']?[0]?['content']?['parts']?[0]?['text'];

      if (rawText == null || rawText is! String) {
        return _fallback();
      }

      final parsed = _safeJsonParse(rawText);
      return parsed ?? _fallback();
    } catch (e) {
      print('Error generating AI summary: $e');
      return _fallback();
    }
  }

  static Map<String, dynamic>? _safeJsonParse(String text) {
    print(text);
    text = text.replaceAll(RegExp(r'```json|```'), '');

    final match = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (match == null) {
      return null;
    }

    try {
      return jsonDecode(match.group(0)!) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> _fallback() {
    return {
      'favorite_item': 'Popular menu items',
      'atmosphere': 'Casual dining environment',
      'accessibility': 'Standard accessibility',
      'highlights': [],
    };
  }
}
