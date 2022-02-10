import 'package:rcv_admin_flutter/src/models/model_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ModelService {
  static String url = '/core/model';
  static Future<List<Model>> getModels(Map<String, dynamic>? params) async {
    List<Model> models = [];
    try {
      final response = await API.list('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        models = data.map((w) => Model.fromMap(w)).toList();
      }
      return models;
    } on ErrorAPI {
      rethrow;
    }
  }
}
