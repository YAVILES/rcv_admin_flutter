import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? token;
  String? refresh;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.token,
    this.refresh,
  });

/*   factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      id: responseData['id'],
      name: responseData['name'],
      email: responseData['email'],
      phone: responseData['phone'],
      token: responseData['token'],
      refresh: responseData['refreshToken'],
    );
  } */

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'token': token,
      'refresh': refresh,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      token: map['token'],
      refresh: map['refresh'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("id", user.id ?? "");
    prefs.setString("name", user.name ?? "");
    prefs.setString("email", user.email ?? "");
    prefs.setString("phone", user.phone ?? "");

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? id = prefs.getString("id");
    String? name = prefs.getString("name");
    String? email = prefs.getString("email");
    String? phone = prefs.getString("phone");
    String? token = prefs.getString("token");
    String? refresh = prefs.getString("refresh");

    return User(
        id: id,
        name: name,
        email: email,
        phone: phone,
        token: token,
        refresh: refresh);
  }

  Future<bool> setToken(String token, String? refresh) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("token", token);
    prefs.setString("refresh", refresh ?? "");

    return prefs.commit();
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("type");
    prefs.remove("token");
  }

  Future<String?> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }

  Future<String?> getRefreshToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refresh = prefs.getString("refresh");
    return refresh;
  }
}
