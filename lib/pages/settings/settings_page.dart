import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _onlyOpenPlaces = false;

  void _showPopup(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: ListView(
        children: [
          const Divider(height: 1),

          SwitchListTile(
            title: const Text(
              "Dark Mode",
              style: TextStyle(fontSize: 16),
            ),
            value: _darkMode,
            activeColor: Colors.black,
            onChanged: (val) {
              setState(() => _darkMode = val);
            },
          ),

          SwitchListTile(
            title: const Text(
              "Only show open places",
              style: TextStyle(fontSize: 16),
            ),
            value: _onlyOpenPlaces,
            activeColor: Colors.black,
            onChanged: (val) {
              setState(() => _onlyOpenPlaces = val);
            },
          ),

          const Divider(height: 24),

          ListTile(
            title: const Text("About"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup("About"),
          ),

          ListTile(
            title: const Text("Terms & Conditions"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup("Terms & Conditions"),
          ),

          ListTile(
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup("Privacy Policy"),
          ),

          ListTile(
            title: const Text("Rate This App"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup("Rate This App"),
          ),

          ListTile(
            title: const Text("Share This App"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup("Share This App"),
          ),
        ],
      ),
    );
  }
}
