import 'dart:convert';
import 'package:http/http.dart' as http;

class AISuggestionsService {
  static const String _apiKey = 'Enter Gemini API key here.';

  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent';

  static Future<List<String>> generateSuggestions(
      List<String> pastQueries, {
        int count = 5,
      }) async {
    if (pastQueries.isEmpty) return [];

    final uri = Uri.parse('$_endpoint?key=$_apiKey');

    final prompt = '''
You generate search query suggestions for a places app.

Based on the user's previous searches, generate exactly $count NEW queries they might search next.

Return ONLY a valid JSON array. No explanations. No markdown.

Format:
["query 1","query 2","query 3","query 4","query 5"]

User history:
${pastQueries.map((q) => '- $q').join('\n')}
''';

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'maxOutputTokens': 1000,
      }
    });

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        // Print body so you can see exact Google error reason
        print('Gemini error ${response.statusCode}: ${response.body}');
        throw Exception('Gemini API error ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final rawText =
      data['candidates']?[0]?['content']?['parts']?[0]?['text'];

      if (rawText == null || rawText is! String) {
        return [];
      }

      return _safeParseSuggestions(rawText);
    } catch (e) {
      print('Error generating suggestions: $e');
      return [];
    }
  }

  static List<String> _safeParseSuggestions(String text) {
    text = text.replaceAll(RegExp(r'```json|```'), '');

    final match = RegExp(r'\[[\s\S]*\]').firstMatch(text);
    if (match == null) return [];

    try {
      final decoded = jsonDecode(match.group(0)!);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
