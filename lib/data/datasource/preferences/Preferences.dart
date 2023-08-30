import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Future<void> saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static const String emailKey = "emailKey";
  static const String passwordKey = "passwordKey";
}
