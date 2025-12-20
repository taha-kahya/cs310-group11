import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _darkModeKey = 'pref_dark_mode';

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getBool(_darkModeKey) ?? false;
    print("🔵 LOAD darkMode = $v (key: $_darkModeKey)");
    return v;
  }

  Future<void> saveDarkMode(bool value) async {
    print("🟢 SAVE darkMode = $value (key: $_darkModeKey)");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
    print("✅ SAVED to SharedPreferences");
  }
}
