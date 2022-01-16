import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UseService {
  static String url = '/core/use';
  static Future<List<Use>?> getUses(Map<String, dynamic>? params) async {
    List<Use> uses = [];
    try {
      final response = await API.list('$url/', params: params);
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
}
