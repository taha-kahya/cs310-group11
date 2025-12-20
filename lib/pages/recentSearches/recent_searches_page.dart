import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:locai/widgets/custom_app_bar.dart';
import 'package:locai/models/search_history.dart';
import 'package:locai/repositories/recent_searches_repository.dart';
import 'package:locai/providers/search_provider.dart';

class RecentSearchesPage extends StatefulWidget {
  const RecentSearchesPage({super.key});

  @override
  State<RecentSearchesPage> createState() => _RecentSearchesPageState();
}

class _RecentSearchesPageState extends State<RecentSearchesPage> {
  late final RecentSearchesRepository _repo;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser!.uid;
    _repo = RecentSearchesRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Recent Searches',
        showBack: true,
        showMenu: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<List<SearchHistory>>(
          stream: _repo.watchSearches(_uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong.'));
            }

            final searches = snapshot.data ?? [];

            if (searches.isEmpty) {
              return const Center(child: Text('No recent searches.'));
            }

            return ListView.separated(
              itemCount: searches.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final search = searches[index];

                return ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(search.query),
                  subtitle: Text(_formatDate(search.createdAt)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _repo.deleteSearch(search.id);
                    },
                  ),
                  onTap: () {
                    context.read<SearchProvider>().setQuery(search.query);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}
