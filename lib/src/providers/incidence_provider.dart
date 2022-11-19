import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/incidence_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class IncidenceProvider with ChangeNotifier {
  String url = '/core/incidence';
  List<Map<String, dynamic>> policies = [];
  Incidence? incidence;
  bool loading = false;
  bool _isDefault = false;

  bool get isDefault => _isDefault;

  Policy? policy;
  Vehicle? vehicle;

  set isDefault(bool isDefault) {
    _isDefault = isDefault;
    notifyListeners();
  }

  late GlobalKey<FormState> formIncidenceKey;

  String? searchValue;

  bool validateForm() {
    return formIncidenceKey.currentState!.validate();
  }

  Future getIncidences() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.get('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        policies = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }

  Future<Incidence?> getIncidence(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Incidence.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newIncidence(Incidence incidenceRCV) async {
    if (validateForm()) {
      final mapData = incidenceRCV.toMapSave();

      final formData = FormData.fromMap(mapData);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          incidence = Incidence.fromMap(response.data);
          getIncidences();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }

  Future<bool?> editIncidence(String id, Incidence incidenceRCV) async {
    if (validateForm()) {
      final mapData = incidenceRCV.toMapSave();

      final formData = FormData.fromMap(mapData);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          incidence = Incidence.fromMap(response.data);
          getIncidences();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }

  Future deleteIncidence(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        policies.removeWhere(
            (incidence) => incidence['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteIncidences(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        policies.removeWhere(
            (incidence) => ids.contains(incidence['id'].toString()));
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
        policies = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }

  setVehicle(Vehicle? _vehicle) {
    vehicle = _vehicle;
    policy = null;
    notifyListeners();
  }

  setPolicy(Policy? _policy) {
    policy = _policy;
  }
}
