import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _showInvalidDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"),
        content: const Text("Please fix the errors in the form."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.public, size: 48, color: Colors.black),
                    SizedBox(width: 12),
                    Text(
                      "LocAI",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                const Text(
                  "Welcome!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign in to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 45),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "USERNAME",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username is required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "username",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "PASSWORD",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "******",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        _showInvalidDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ------- UPDATED: now clickable but same look -------
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/forgot-password"),
                  child: const Text(
                    "Forgot your password?",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 14),

                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/sign-up"),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
