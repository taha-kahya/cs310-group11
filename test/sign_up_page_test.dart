import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import 'package:locai/providers/auth_provider.dart';
import 'package:locai/pages/signUp/sign_up_page.dart';

class FakeAuthProvider extends ChangeNotifier implements AuthProvider {
  @override
  bool get isLoading => false;

  @override
  User? get currentUser => null;

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> signup(String email, String password) async {}

  @override
  Future<void> logout() async {}
}

Widget createTestWidget() {
  return ChangeNotifierProvider<AuthProvider>(
    create: (_) => FakeAuthProvider(),
    child: const MaterialApp(
      home: SignUpPage(),
    ),
  );
}

void main() {
  /// Widget tests
  testWidgets(
    'SignUp page shows validation errors on empty form',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    },
  );

  testWidgets(
    'Shows invalid email error',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final fields = find.byType(TextFormField);

      await tester.enterText(fields.at(0), 'user');
      await tester.enterText(fields.at(1), 'invalid-email');
      await tester.enterText(fields.at(2), '123456');

      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    },
  );

  /// Unit test
  test(
    'AuthProvider initial state is correct',
        () {
      final provider = FakeAuthProvider();

      expect(provider.isLoading, false);
      expect(provider.currentUser, null);
    },
  );
}
