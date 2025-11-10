import 'package:flutter/material.dart';
import 'package:locai/utils/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Welcome to LocAI!',
        style: AppTextStyles.body,
      ),
    );
  }
}
