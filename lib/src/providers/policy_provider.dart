import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/client_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PolicyProvider with ChangeNotifier {
  String url = '/core/policy';
  List<Map<String, dynamic>> policies = [];
  Policy? policy;
  bool loading = false;
  bool _isDefault = false;

  bool get isDefault => _isDefault;

  Client? taker;
  Vehicle? vehicle;

  set isDefault(bool isDefault) {
    _isDefault = isDefault;
    notifyListeners();
  }

  late GlobalKey<FormState> formPolicyKey;

  String? searchValue;

  bool validateForm() {
    return formPolicyKey.currentState!.validate();
  }

  Future getPolicies() async {
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
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  Future<Policy?> getPolicy(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Policy.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newPolicy(Policy policyRCV) async {
    if (validateForm()) {
      final mapData = policyRCV.toMapSave();

      final formData = FormData.fromMap(mapData);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          policy = Policy.fromMap(response.data);
          getPolicies();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future<bool?> editPolicy(String id, Policy policyRCV) async {
    if (validateForm()) {
      final mapData = policyRCV.toMapSave();

      final formData = FormData.fromMap(mapData);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          policy = Policy.fromMap(response.data);
          getPolicies();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deletePolicy(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        policies
            .removeWhere((Policy) => Policy['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deletePolicies(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        policies.removeWhere((Policy) => ids.contains(Policy['id'].toString()));
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

  setTaker(Client? _taker) {
    taker = _taker;
    notifyListeners();
  }

  setVehicle(Vehicle? _vehicle) {
    vehicle = _vehicle;
    notifyListeners();
  }
}
