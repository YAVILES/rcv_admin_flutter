import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class SectionService {
  static String url = '/core/section';

  // Tipos
  static String get box => 'box';
  static String get about => 'about';
  static String get service => 'service';
  static String get partner => 'partner';

  static Future<List<Option>?> getTypes() async {
    try {
      final response =
          await API.get('$url/field_options/', params: {"field": "type"});
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        return data.map((w) => Option.fromMap(w)).toList();
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }
}
