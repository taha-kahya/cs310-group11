import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:locai/providers/settings_provider.dart';
import 'package:locai/state/preferences_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showPopup(BuildContext context, String title) {
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
    final settings = context.watch<SettingsProvider>();
    final prefs = context.watch<PreferencesState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
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
            value: prefs.darkMode,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (v) {
              context.read<PreferencesState>().setDarkMode(v);
            },
          ),


          SwitchListTile(
            title: const Text(
              "Only show open places",
              style: TextStyle(fontSize: 16),
            ),
            value: settings.onlyOpenPlaces,
            activeTrackColor: Theme.of(context).colorScheme.primary,
            onChanged: (_) {
              context.read<SettingsProvider>().toggleOnlyOpenPlaces();
            },
          ),

          const Divider(height: 24),

          ListTile(
            title: const Text("About"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup(context, "About"),
          ),
          ListTile(
            title: const Text("Terms & Conditions"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup(context, "Terms & Conditions"),
          ),
          ListTile(
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup(context, "Privacy Policy"),
          ),
          ListTile(
            title: const Text("Rate This App"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup(context, "Rate This App"),
          ),
          ListTile(
            title: const Text("Share This App"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPopup(context, "Share This App"),
          ),
        ],
      ),
    );
  }
}