import 'package:dio/dio.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UseService {
  static String url = '/core/use';
  static Future<List<Use>?> getUses(Map<String, dynamic>? params) async {
    List<Use> uses = [];
    try {
      final response = await API.get('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        uses = data.map((w) => Use.fromMap(w)).toList();
      }
      return uses;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<Use?> getUse(String uid, String? plan) async {
    try {
      Response response;
      if (plan != null) {
        response = await API.get('$url/$uid/?plan=$plan');
      } else {
        response = await API.get('$url/$uid/');
      }
      if (response.statusCode == 200) {
        return Use.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }
}
