import 'package:rcv_admin_flutter/src/models/branch_office_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BranchOfficeService {
  static String url = '/core/branch_office';
  static Future<List<BranchOffice>> getAll(Map<String, dynamic>? params) async {
    List<BranchOffice> branchOffices = [];
    try {
      final response = await API.get('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        branchOffices = data.map((w) => BranchOffice.fromMap(w)).toList();
      }
      return branchOffices;
    } on ErrorAPI {
      rethrow;
    }
  }
}
