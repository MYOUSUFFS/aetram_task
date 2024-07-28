
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
}
