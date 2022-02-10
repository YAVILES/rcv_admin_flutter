import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class VehicleService {
  static String url = '/core/vehicle';
  static Future<List<Vehicle>> getVehicles(Map<String, dynamic>? params) async {
    List<Vehicle> vehicles = [];
    try {
      final response = await API.list('$url/', params: params);
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

  static Future<List<Option>> fieldOption(String field) async {
    List<Option> options = [];
    try {
      final response =
          await API.list('$url/field_option/', params: {field: field});
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        options = data.map((w) => Option.fromMap(w)).toList();
      }
      return options;
    } on ErrorAPI {
      rethrow;
    }
  }
}
