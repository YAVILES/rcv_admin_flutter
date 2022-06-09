import 'package:rcv_admin_flutter/src/utils/api.dart';

class HomeService {
  static String url = '';

  static Future<Map<String, dynamic>?> getData() async {
    try {
      final response = await API.list('$url/home_data/');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
      return null;
    } on ErrorAPI {
      rethrow;
    }
  }
}
