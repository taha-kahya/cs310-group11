import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart' show User;

import 'package:locai/providers/auth_provider.dart';
import 'package:locai/pages/signIn/sign_in_page.dart';

class FakeAuthProvider extends ChangeNotifier
    implements AuthProvider {

  @override
  bool get isLoading => false;

  @override
  User? get currentUser => null;

  @override
  Future<void> login(String email, String password) async {
    // no-op
  }

  @override
  Future<void> signup(String email, String password) async {
    // no-op
  }

  @override
  Future<void> logout() async {
    // no-op
  }
}

void main() {
  testWidgets('SignIn page shows all elements', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: FakeAuthProvider(),
        child: const MaterialApp(home: SignInPage()),
      ),
    );

    expect(find.text('LocAI'), findsOneWidget);
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('Shows error for empty email', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: FakeAuthProvider(),
        child: const MaterialApp(home: SignInPage()),
      ),
    );

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
  });

  testWidgets('Shows error for invalid email', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: FakeAuthProvider(),
        child: const MaterialApp(home: SignInPage()),
      ),
    );

    await tester.enterText(
      find.byType(TextFormField).first,
      'bademail',
    );

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Enter a valid email'), findsOneWidget);
  });
}
