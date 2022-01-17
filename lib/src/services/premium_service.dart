import 'package:rcv_admin_flutter/src/models/premium_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PremiumService {
  static String url = '/core/premium';

  static Future<bool?> saveMultiple(List<Premium> premiums) async {
    try {
      final response = await API.add('$url/multiple/',
          {'premiums': premiums.map((x) => x.toMap()).toList()});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on ErrorAPI {
      rethrow;
    }
  }
}
