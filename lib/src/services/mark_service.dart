import 'package:rcv_admin_flutter/src/models/mark_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class MarkService {
  static String url = '/core/mark';
  static Future<List<Mark>> getMarks(Map<String, dynamic>? params) async {
    List<Mark> marks = [];
    try {
      final response = await API.list('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        marks = data.map((w) => Mark.fromMap(w)).toList();
      }
      return marks;
    } on ErrorAPI {
      rethrow;
    }
  }
}
