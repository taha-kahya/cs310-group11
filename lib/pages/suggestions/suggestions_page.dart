import 'package:flutter/material.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {

  final List<String> suggestions = [
    'Sushi, noodles, and flavors',
    'Quick, fresh, and flavorful ramen',
    'Comfy, quiet place with convenient charging',
  ];

  void _onSuggestionTap(String suggestion) {
    print('Selected suggestion: $suggestion');
    // Navigator.pushNamed(context, '/home');
  }

  void _quickSearch() {
    print('Select one to search quickly');
    if (suggestions.isNotEmpty) {
      _onSuggestionTap(suggestions[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Based on your favorites, some ideas you may like',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'Select one to search quickly',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _quickSearch,
              child: const Text('Quick Search'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(suggestion),
                      onTap: () => _onSuggestionTap(suggestion),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}