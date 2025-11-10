import 'package:flutter/material.dart';
import 'package:locai/widgets/custom_app_bar.dart';
import 'package:locai/pages/home/home_page.dart';
import 'package:locai/pages/favorites/favorites_page.dart';
import 'package:locai/pages/suggestions/suggestions_page.dart';
import 'package:locai/pages/profile/profile_page.dart';

class MainShell extends StatefulWidget {
  final int initialIndex; // which tab

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  final _titles = ['Home', 'Favorites', 'Suggestions', 'Profile'];

  final _pages = const [
    HomePage(title: "LocalAI",),
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

    // Map each tab to a unique route name
    const routes = ['/home', '/favorites', '/suggestions', '/profile'];

    // Replace current route so back stack stays clean
    Navigator.pushReplacementNamed(context, routes[i]);
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
    );
  }
}
