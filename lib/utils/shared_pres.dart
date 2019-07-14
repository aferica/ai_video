import 'package:shared_preferences/shared_preferences.dart';

class SharedPres {
  static Future<String> get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = await prefs.getString(key);
    print(value);
    return  prefs.getString(key);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<bool> set(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(await prefs.setString('key', value));
    return await prefs.setString('key', value);
  }

  static Future<bool> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('key', value);
  }

  static Future<bool> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt('key', value);
  }
}