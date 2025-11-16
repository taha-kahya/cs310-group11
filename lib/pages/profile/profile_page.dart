import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 70),

          // Profile Icon
          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFF333333),
            child: Icon(
              Icons.person,
              size: 65,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          // Username
          const Text(
            "Username",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 30),


          _ProfileOption(
            title: "Reset password",
            onTap: () {},
          ),

          _ProfileOption(
            title: "Change username",
            onTap: () {},
          ),

          _ProfileOption(
            title: "Notifications",
            onTap: () {},
          ),

          _ProfileOption(
            title: "Log Out",
            colorRed: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool colorRed;

  const _ProfileOption({
    required this.title,
    required this.onTap,
    this.colorRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: colorRed ? Colors.red : Colors.black87,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
