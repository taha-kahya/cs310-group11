import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Email Sent"),
        content: const Text(
          "If an account with this email exists, a password reset link has been sent.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to sign-in
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return email.contains("@") && email.contains(".");
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
              children: [
                const SizedBox(
                  height: 110,
                ), // <<-- increased from 60 to center page
                // ---------- LOGO ----------
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 80,
                ), // <<-- increased from 50 to center page

                const Text(
                  "Reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16), // slightly increased
                const Text(
                  "Enter your email and we’ll send you a reset link.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),

                const SizedBox(height: 55), // <<-- increased from 40
                // EMAIL FIELD
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "EMAIL",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // slightly increased
                TextFormField(
                  controller: _emailCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!_isValidEmail(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "username@email.com",
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

                const SizedBox(height: 55), // <<-- increased from 40
                // SEND BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showConfirmation();
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
                      "Send reset link",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40), // spacing before back button

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 60), // extra bottom space
              ],
            ),
          ),
        ),
      ),
    );
  }
}
