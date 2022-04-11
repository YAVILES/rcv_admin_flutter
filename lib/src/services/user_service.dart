import 'package:dio/dio.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UserService {
  static String url = '/security/user';
  static Future<List<User>?> getUsers(Map<String, dynamic>? params) async {
    List<User> uses = [];
    try {
      final response = await API.list('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        uses = data.map((w) => User.fromMap(w)).toList();
      }
      return uses;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<User?> getUser(String uid) async {
    try {
      Response response;
      response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return User.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }
}
