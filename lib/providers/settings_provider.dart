import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _onlyOpenPlaces = false;

  bool get isDarkMode => _isDarkMode;
  bool get onlyOpenPlaces => _onlyOpenPlaces;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _onlyOpenPlaces = prefs.getBool('onlyOpenPlaces') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleOnlyOpenPlaces() async {
    _onlyOpenPlaces = !_onlyOpenPlaces;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onlyOpenPlaces', _onlyOpenPlaces);
    notifyListeners();
  }
}