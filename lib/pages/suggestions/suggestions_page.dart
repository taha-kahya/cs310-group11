import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:locai/providers/auth_provider.dart';
import 'package:locai/providers/search_provider.dart';

import 'package:locai/models/search_history.dart';
import 'package:locai/repositories/recent_searches_repository.dart';
import 'package:locai/services/ai_suggestions_service.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final RecentSearchesRepository _repo = RecentSearchesRepository();

  List<String> _suggestions = [];
  bool _isLoading = false;
  bool _hasRequested = false;

  Future<void> _generateSuggestions(List<String> pastQueries) async {
    if (pastQueries.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final results = await AISuggestionsService.generateSuggestions(
      pastQueries,
      count: 5,
    );

    if (!mounted) return;

    setState(() {
      _suggestions = results;
      _isLoading = false;
    });
  }

  void _onSuggestionTap(String suggestion) {
    context.read<SearchProvider>().setQuery(suggestion);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to see suggestions')),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Based on your recent searches, some ideas you may like',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Select one to search quickly',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            Expanded(
              child: StreamBuilder<List<SearchHistory>>(
                stream: _repo.watchSearches(user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final histories = snapshot.data!;
                  final pastQueries =
                  histories.map((e) => e.query).toList();

                  // ✅ Schedule AI call AFTER build (SAFE)
                  if (!_hasRequested) {
                    _hasRequested = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _generateSuggestions(pastQueries);
                      }
                    });
                  }

                  if (_isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (_suggestions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No suggestions available yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final suggestion = _suggestions[index];

                      return Card(
                        elevation: 2,
                        child: ListTile(
                          title: Text(suggestion),
                          onTap: () => _onSuggestionTap(suggestion),
                        ),
                      );
                    },
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
