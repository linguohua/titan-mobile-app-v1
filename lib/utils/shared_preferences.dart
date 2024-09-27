import 'package:shared_preferences/shared_preferences.dart';

///cache层抽取一下，方便使用和更换
class TTSharedPreferences {
  static late SharedPreferences _preferences;

  //初始化动作
  static Future<void> setUp() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Set<String> getKeys() {
    Set<String> keys = _preferences.getKeys();
    return keys;
  }

  static Object? get(String key) {
    Object? result = _preferences.get(key);
    return result;
  }

  static bool? getBool(String key) {
    bool? result = _preferences.getBool(key);
    return result;
  }

  static int? getInt(String key) {
    int? result = _preferences.getInt(key);
    return result;
  }

  static Future<double?> getDouble(String key) async {
    double? result = _preferences.getDouble(key);
    return result;
  }

  static String? getString(String key) {
    String? result = _preferences.getString(key);
    return result;
  }

  static bool containsKey(String key) {
    bool result = _preferences.containsKey(key);
    return result;
  }

  static List<String>? getStringList(String key) {
    List<String>? result = _preferences.getStringList(key);
    return result;
  }

  static Future<bool> setBool(String key, bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = await preferences.setBool(key, value);
    return result;
  }

  static Future<bool> setInt(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = await preferences.setInt(key, value);
    return result;
  }

  static Future<bool> setDouble(String key, double value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = await preferences.setDouble(key, value);
    return result;
  }

  static Future<bool> setString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = await preferences.setString(key, value);
    return result;
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = await preferences.setStringList(key, value);
    return result;
  }

  static Future<bool> remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool result = await preferences.remove(key);
    return result;
  }
}
