import 'package:rcv_admin_flutter/src/models/role_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class RoleService {
  static String url = '/security/role';
  static Future<List<Role>> getRoles(Map<String, dynamic>? params) async {
    List<Role> roles = [];
    try {
      final response = await API.get('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        roles = data.map((w) => Role.fromMap(w)).toList();
      }
      return roles;
    } on ErrorAPI {
      rethrow;
    }
  }
}
