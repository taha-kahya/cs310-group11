import 'package:flutter/material.dart';

class NoPlacesFoundPage extends StatefulWidget {
  const NoPlacesFoundPage({super.key});

  @override
  State<NoPlacesFoundPage> createState() => _NoPlacesFoundPageState();
}

class _NoPlacesFoundPageState extends State<NoPlacesFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("No Places Found")),
      body: const Center(
        child: Text('No Places Found Page'),
      ),
    );
  }
}
