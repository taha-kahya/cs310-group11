import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:locai/auth/auth_gate.dart';

import 'package:locai/layout/main_shell.dart';
import 'package:locai/pages/signIn/sign_in_page.dart';
import 'package:locai/pages/signUp/sign_up_page.dart';
import 'package:locai/pages/placeDetails/place_details_page.dart';
import 'package:locai/pages/settings/settings_page.dart';
import 'package:locai/pages/recentSearches/recent_searches_page.dart';
import 'package:locai/pages/giveFeedback/give_feedback_page.dart';
import 'package:locai/pages/reportBug/report_bug_page.dart';
import 'package:locai/pages/forgot_password/forgot_password_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocAI',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
        ),
      ),

      // Firebase Authentication Gate
      home: const AuthGate(),

      // App routes (still usable for navigation)
      routes: {
        '/home': (context) => const MainShell(initialIndex: 0),
        '/favorites': (context) => const MainShell(initialIndex: 1),
        '/suggestions': (context) => const MainShell(initialIndex: 2),
        '/profile': (context) => const MainShell(initialIndex: 3),

        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),

        '/place-details': (context) => const PlaceDetailsPage(),
        '/settings': (context) => const SettingsPage(),
        '/recent-searches': (context) => const RecentSearchesPage(),
        '/give-feedback': (context) => const GiveFeedbackPage(),
        '/report-bug': (context) => const ReportBugPage(),
      },
    );
  }
}
