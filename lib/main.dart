import 'package:flutter/material.dart';
import 'package:locai/pages/home/home_page.dart';
import 'package:locai/pages/signIn/sign_in_page.dart';
import 'package:locai/pages/signUp/sign_up_page.dart';
import 'package:locai/pages/placeDetails/place_details_page.dart';
import 'package:locai/pages/favorites/favorites_page.dart';
import 'package:locai/pages/suggestions/suggestions_page.dart';
import 'package:locai/pages/profile/profile_page.dart';
import 'package:locai/pages/settings/settings_page.dart';
import 'package:locai/pages/noPlacesFound/no_places_found_page.dart';
import 'package:locai/pages/recentSearches/recent_searches_page.dart';
import 'package:locai/pages/giveFeedback/give_feedback_page.dart';
import 'package:locai/pages/reportBug/report_bug_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocAI',
      initialRoute: '/home',
      routes: {
        '/home':(context) => const HomePage(title: 'LocAI'),
        '/sign-in':(context) => const SignInPage(),
        '/sign-up':(context) => const SignUpPage(),
        '/place-details':(context) => const PlaceDetailsPage(),
        '/favorites':(context) => const FavoritesPage(),
        '/suggestions':(context) => const SuggestionsPage(),
        '/profile':(context) => const ProfilePage(),
        '/settings':(context) => const SettingsPage(),
        '/no-places-found':(context) => const NoPlacesFoundPage(),
        '/recent-searches':(context) => const RecentSearchesPage(),
        '/give-feedback':(context) => const GiveFeedbackPage(),
        '/report-bug':(context) => const ReportBugPage()
      },
    );
  }
}

