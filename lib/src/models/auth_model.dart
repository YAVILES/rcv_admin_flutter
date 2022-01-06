// To parse this JSON data, do
//
//     final auth = authFromMap(jsonString);

import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/user_model.dart';

class Auth {
  String token;
  String refresh;
  User? user;

  Auth({
    required this.token,
    required this.refresh,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'refresh': refresh,
      'user': user?.toMap(),
    };
  }

  factory Auth.fromMap(Map<String, dynamic> map) {
    return Auth(
      token: map['token'] ?? '',
      refresh: map['refresh'] ?? '',
      user: User.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Auth.fromJson(String source) => Auth.fromMap(json.decode(source));
}
