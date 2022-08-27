import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class VehicleService {
  static String url = '/core/vehicle';
  static Future<List<Vehicle>> getVehicles(Map<String, dynamic>? params) async {
    List<Vehicle> vehicles = [];
    try {
      final response = await API.get('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        vehicles = data.map((w) => Vehicle.fromMap(w)).toList();
      }
      return vehicles;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<List<Option>> fieldOptions(String field) async {
    List<Option> _options = [];
    try {
      final response =
          await API.get('$url/field_options/', params: {'field': field});
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        _options = data.map((w) => Option.fromMap(w)).toList();
      }
      return _options;
    } on ErrorAPI {
      rethrow;
    }
  }
}
