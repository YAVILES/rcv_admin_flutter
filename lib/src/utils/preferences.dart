import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences prefs;

  static Future<SharedPreferences> configurePrefs() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static Future<void> setToken(String token, String? refresh) async {
    prefs.setString("token", token);
    prefs.setString("refresh", refresh ?? "");
  }

  static void removetoken() async {
    prefs.remove("token");
    prefs.remove("refresh");
  }

  static String? getToken() {
    return prefs.getString("token");
  }

  static Future<String?> getRefreshToken(args) async {
    return prefs.getString("refresh");
  }
}
