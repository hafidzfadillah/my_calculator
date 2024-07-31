import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String IS_LOGIN = "IS_LOGIN";
  static const String KEY_NAME = "KEY_NAME";
  static const String KEY_EMAIL = "KEY_EMAIL";
  static const String KEY_DOB = "KEY_DOB";
  static const String KEY_GENDER = "KEY_GENDER";

  static void createLoginSession(name, email) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(IS_LOGIN, true);
    prefs.setString(KEY_NAME, name);
    prefs.setString(KEY_EMAIL, email);
  }

  static Future<String> getData(key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }

  static Future<bool> getDataBool(key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key) ?? false;
  }

  static void updateDataString(key, value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  static void updateDataBool(key, value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(key, value);
  }

  static Future<bool> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.clear();
  }
}
