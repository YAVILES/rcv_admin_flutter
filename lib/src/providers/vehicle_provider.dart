import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class VehicleProvider with ChangeNotifier {
  String url = '/core/vehicle';
  List<Map<String, dynamic>> vehicles = [];
  Vehicle? vehicle;
  bool loading = false;
  bool _isDefault = false;

  bool get isDefault => _isDefault;

  set isDefault(bool isDefault) {
    _isDefault = isDefault;
    notifyListeners();
  }

  late GlobalKey<FormState> formVehicleKey;

  String? searchValue;

  bool validateForm() {
    return formVehicleKey.currentState!.validate();
  }

  Future getVehicles() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        vehicles = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  Future<Vehicle?> getVehicle(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Vehicle.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newVehicle(Vehicle vehicleRCV) async {
    if (validateForm()) {
      final mapDAta = vehicleRCV.toMap();
      final formData = FormData.fromMap(mapDAta);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          vehicle = Vehicle.fromMap(response.data);
          getVehicles();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future<bool?> editVehicle(String id, Vehicle vehicleRCV) async {
    if (validateForm()) {
      final mapDAta = vehicleRCV.toMap();
      final formData = FormData.fromMap(mapDAta);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          vehicle = Vehicle.fromMap(response.data);
          getVehicles();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deleteVehicle(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        vehicles.removeWhere(
            (vehicle) => vehicle['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteVehicles(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        vehicles
            .removeWhere((vehicle) => ids.contains(vehicle['id'].toString()));
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  search(value) async {
    searchValue = value;
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/', params: {"search": value});
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        vehicles = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }
}
