import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>(
    create: (ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const fooKey = 'fooBoolTest';
  static const uidKey = 'userId';

  Future<void> setFooBoolTest() async {
    await sharedPreferences.setBool(fooKey, true);
  }

  bool isFooBoolTest() => sharedPreferences.getBool(fooKey) ?? false;

  Future<void> setUID(String uid) async {
    await sharedPreferences.setString(uidKey, uid);
  }

  String? getUID() => sharedPreferences.getString(uidKey);

  static Future<void> saveGestureList(List gesture) async {
    //await sharedPreferences.setString(uidKey, uid);
    var s = json.encode(gesture);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("gestures", s);
  }

  static Future<List> getGestureList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var gestures = [];
    String? gestureString = await sharedPreferences.getString("gestures");
    gestures = json.decode(gestureString as String);
    return gestures;
  }

  static Future<void> saveCustomGestureText(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(key, value);
  }

  static Future<String?> getCustomGestureText(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? value = await sharedPreferences.getString(key);
    print("getting gestu");
    print(value);
    return value;
  }
}