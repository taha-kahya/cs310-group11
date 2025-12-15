import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locai/providers/auth_provider.dart';
import 'package:locai/layout/main_shell.dart';
import 'package:locai/pages/signIn/sign_in_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.currentUser != null) {
      return const MainShell(initialIndex: 0);
    }

    return const SignInPage();
  }
}
