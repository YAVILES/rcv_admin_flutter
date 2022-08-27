import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class VehicleProvider with ChangeNotifier {
  String url = '/core/vehicle';
  List<Map<String, dynamic>> vehicles = [];
  Vehicle? vehicle;
  Use? use;
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
      final response = await API.get('$url/');
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
      final mapData = {
        if (vehicleRCV.ownerIdentityCardImageFile?.bytes != null)
          'owner_identity_card_image': MultipartFile.fromBytes(
            vehicleRCV.ownerIdentityCardImageFile!.bytes!,
            filename: vehicleRCV.ownerIdentityCardImageFile!.name,
          ),
        if (vehicleRCV.ownerCirculationCardFile?.bytes != null)
          'owner_circulation_card': MultipartFile.fromBytes(
            vehicleRCV.ownerCirculationCardFile!.bytes!,
            filename: vehicleRCV.ownerCirculationCardFile!.name,
          ),
        if (vehicleRCV.ownerLicenseFile?.bytes != null)
          'owner_license': MultipartFile.fromBytes(
            vehicleRCV.ownerLicenseFile!.bytes!,
            filename: vehicleRCV.ownerLicenseFile!.name,
          ),
        ...vehicleRCV.toMapSave(),
      };

      final formData = FormData.fromMap(mapData);
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
      final mapData = {
        if (vehicleRCV.ownerIdentityCardImageFile?.bytes != null)
          'owner_identity_card_image': MultipartFile.fromBytes(
            vehicleRCV.ownerIdentityCardImageFile!.bytes!,
            filename: vehicleRCV.ownerIdentityCardImageFile!.name,
          ),
        if (vehicleRCV.ownerCirculationCardFile?.bytes != null)
          'owner_circulation_card': MultipartFile.fromBytes(
            vehicleRCV.ownerCirculationCardFile!.bytes!,
            filename: vehicleRCV.ownerCirculationCardFile!.name,
          ),
        if (vehicleRCV.ownerLicenseFile?.bytes != null)
          'owner_license': MultipartFile.fromBytes(
            vehicleRCV.ownerLicenseFile!.bytes!,
            filename: vehicleRCV.ownerLicenseFile!.name,
          ),
        ...vehicleRCV.toMapSave(),
      };

      final formData = FormData.fromMap(mapData);

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
      final response = await API.get('$url/', params: {"search": value});
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

  Future dowmloadArchive(String id, String archive) async {
    try {
      final response = await API.get(
        '$url/$id/download_archive/?archive=$archive',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }
      return null;
    } on ErrorAPI {
      rethrow;
    }
  }

  notifyUse(Use? _use) {
    use = _use;
    notifyListeners();
  }
}
