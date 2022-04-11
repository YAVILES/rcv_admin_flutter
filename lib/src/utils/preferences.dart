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

  static Future<void> setWorkflows(String workflows) async {
    prefs.setString("workflows", workflows);
  }

  static String? getWorkflows() {
    return prefs.getString("workflows");
  }

  static void removetoken() async {
    prefs.remove("token");
    prefs.remove("refresh");
  }

  static String? getToken() {
    return prefs.getString("token");
  }

  static String? getRefreshToken() {
    return prefs.getString("refresh");
  }

  static Future<void> setIdUser(String id) async {
    prefs.setString("id_user", id);
  }

  static String? getIdUser() {
    return prefs.getString("id_user");
  }
}
