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
    print("🚀 PreferencesState.init() STARTED");
    _darkMode = await _prefs.loadDarkMode();
    _initialized = true;
    print("✅ PreferencesState initialized with darkMode = $_darkMode");
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    print("🔄 setDarkMode($value) called");
    _darkMode = value;
    notifyListeners();              // UI hemen değişsin
    await _prefs.saveDarkMode(value); // sonra telefona kaydet
    print("✅ setDarkMode complete");
  }
}
