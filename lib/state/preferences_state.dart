import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class PreferencesState extends ChangeNotifier {
  final PreferencesService _prefs;

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  bool _initialized = false;
  bool get initialized => _initialized;

  PreferencesState(this._prefs);

  Future<void> init() async {
    _darkMode = await _prefs.loadDarkMode();
    _initialized = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    notifyListeners();
    await _prefs.saveDarkMode(value);
  }
}
