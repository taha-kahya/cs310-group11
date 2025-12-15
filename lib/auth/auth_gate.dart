import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:locai/layout/main_shell.dart';
import 'package:locai/pages/signIn/sign_in_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainShell(initialIndex: 0);
        }

        return const SignInPage();
      },
    );
  }
}
