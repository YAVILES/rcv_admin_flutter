import 'package:rcv_admin_flutter/src/models/configuration_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ConfigurationService {
  static String url = '/system/configuration';

  static Future<Configuration?> get(String key) async {
    try {
      final response =
          await API.get('$url/retrieve_for_key/', params: {"key": key});
      if (response.statusCode == 200) {
        return Configuration.fromMap(response.data);
      }
    } on ErrorAPI {
      rethrow;
    }
    return null;
  }

  static Future updateConfig(int id, Configuration config) async {
    try {
      final response = await API.put('$url/$id/', config.toMap());
      if (response.statusCode == 200) {
        return true; // Configuration.fromMap(response.data);
      }
    } on ErrorAPI {
      rethrow;
    }
    return null;
  }
}
