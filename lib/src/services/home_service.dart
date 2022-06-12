import 'package:rcv_admin_flutter/src/utils/api.dart';

class HomeService {
  static String url = '/core/home';

  static Future<Map<String, dynamic>?> getData() async {
    try {
      final response = await API.list('$url/data/');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
      return null;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getPolicyForBranchOffice() async {
    try {
      final response = await API.list('$url/policy_for_branch_office/');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } on ErrorAPI {
      rethrow;
    }
  }
}
