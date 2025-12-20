import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:locai/providers/favorites_provider.dart';
import 'package:locai/providers/settings_provider.dart';
import 'package:locai/repositories/favorites_repository.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:locai/providers/auth_provider.dart';
import 'package:locai/providers/search_provider.dart';
import 'package:locai/auth/auth_gate.dart';

import 'package:locai/pages/signIn/sign_in_page.dart';
import 'package:locai/pages/signUp/sign_up_page.dart';
import 'package:locai/pages/forgot_password/forgot_password_page.dart';
import 'package:locai/pages/placeDetails/place_details_page.dart';
import 'package:locai/pages/settings/settings_page.dart';
import 'package:locai/pages/recentSearches/recent_searches_page.dart';
import 'package:locai/pages/giveFeedback/give_feedback_page.dart';
import 'package:locai/pages/reportBug/report_bug_page.dart';

import 'package:locai/services/preferences_service.dart';
import 'package:locai/state/preferences_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => PreferencesService()),
        ChangeNotifierProvider(
          create: (ctx) => PreferencesState(ctx.read<PreferencesService>()),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(FavoritesRepository())),
        ChangeNotifierProvider(create: (_) => SearchProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PreferencesState>().init());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesState>(
      builder: (context, prefs, _) {
        if (!prefs.initialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'LocAI',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 16),
              bodyMedium: TextStyle(fontSize: 14),
              bodySmall: TextStyle(fontSize: 12),
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
              bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
              bodySmall: TextStyle(fontSize: 12, color: Colors.white60),
            ),
          ),

          themeMode: prefs.darkMode ? ThemeMode.dark : ThemeMode.light,

          home: const AuthGate(),

          routes: {
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
      },
    );
  }
}
