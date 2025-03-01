import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setTemp(String name) async {
    await _preferences?.setString('temp', name);
  }

  static String? getTemp() {
    return _preferences?.getString('temp');
  }

  static Future setCategory(String? name) async {
    if (name != null) {
      await _preferences?.setString('category', name);
    } else {
      await _preferences?.remove('category');
    }
  }

  static String? getCategory() {
    return _preferences?.getString('category');
  }
}
