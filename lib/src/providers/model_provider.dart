import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/model_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ModelProvider with ChangeNotifier {
  String url = '/core/model';
  List<Map<String, dynamic>> models = [];
  Model? model;
  bool loading = false;
  bool _isDefault = false;

  bool get isDefault => _isDefault;

  set isDefault(bool isDefault) {
    _isDefault = isDefault;
    notifyListeners();
  }

  late GlobalKey<FormState> formModelKey;

  String? searchValue;

  bool validateForm() {
    return formModelKey.currentState!.validate();
  }

  Future getModels() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        models = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  Future<Model?> getModel(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Model.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newModel(Model modelRCV) async {
    if (validateForm()) {
      final mapDAta = modelRCV.toMap();
      final formData = FormData.fromMap(mapDAta);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          model = Model.fromMap(response.data);
          getModels();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future<bool?> editModel(String id, Model modelRCV) async {
    if (validateForm()) {
      final mapDAta = modelRCV.toMap();
      final formData = FormData.fromMap(mapDAta);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          model = Model.fromMap(response.data);
          getModels();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deleteModel(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        models.removeWhere((model) => model['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteModels(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        models.removeWhere((model) => ids.contains(model['id'].toString()));
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
        models = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }
}
