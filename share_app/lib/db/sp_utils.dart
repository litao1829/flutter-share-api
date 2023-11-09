import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  SharedPreferences? _prefs;
  static SpUtils? _instance;
  SpUtils.of() {
    init();
  }
  SpUtils._pre(SharedPreferences prefs) {
    _prefs = prefs;
  }
  static SpUtils getInstance() {
    _instance ??= SpUtils.of();
    return _instance!;
  }
  void init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  static Future<SpUtils> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = SpUtils._pre(prefs);
    }
    return _instance!;
  }
  void setData<T>(String key, T data) {
    if (data is String) {
      _prefs?.setString(key, data);
    } else if (data is double) {
      _prefs?.setDouble(key, data);
    } else if (data is int) {
      _prefs?.setInt(key, data);
    } else if (data is bool) {
      _prefs?.setBool(key, data);
    } else if (data is List<String>) {
      _prefs?.setStringList(key, data);
    }
  }
  void remove(String key) {
    _prefs?.remove(key);
  }
  T? get<T>(String key, T defaultValue) {
    var value = _prefs?.get(key);
    if (value != null) {
      return value as T;
    }
    return defaultValue;
  }
}