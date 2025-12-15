import 'package:flutter/material.dart';
import 'package:locai/pages/giveFeedback/give_feedback_page.dart';
import 'package:locai/pages/recentSearches/recent_searches_page.dart';
import 'package:locai/pages/reportBug/report_bug_page.dart';
import 'package:locai/pages/settings/settings_page.dart';
import 'package:locai/widgets/custom_app_bar.dart';
import 'package:locai/pages/home/home_page.dart';
import 'package:locai/pages/favorites/favorites_page.dart';
import 'package:locai/pages/suggestions/suggestions_page.dart';
import 'package:locai/pages/profile/profile_page.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  final _titles = ['Home', 'Favorites', 'Suggestions', 'Profile'];

  final _pages = const [
    HomePage(),
    FavoritesPage(),
    SuggestionsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  void _onTabSelected(int i) {
    if (i == _index) return;

    setState(() {
      _index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_index]),
      body: _pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Suggestions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),

      // Drawer routes are OK (they are NOT MainShell)
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(
                "LocAI",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Recent Searches"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RecentSearchesPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Give Feedback"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GiveFeedbackPage()),
                );
              },
            ),
            ListTile(
              title: const Text("Report Bug"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportBugPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
