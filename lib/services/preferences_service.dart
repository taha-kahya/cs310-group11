import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _darkModeKey = 'pref_dark_mode';

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }
}
