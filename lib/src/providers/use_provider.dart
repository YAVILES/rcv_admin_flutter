import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UseProvider with ChangeNotifier {
  String url = '/core/use';
  List<Map<String, dynamic>> uses = [];
  Use? use;
  bool loading = false;

  late GlobalKey<FormState> formUseKey;

  String? searchValue;

  bool validateForm() {
    return formUseKey.currentState!.validate();
  }

  Future getUses() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        uses = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<Use?> getUse(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Use.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newUse(Use useRCV) async {
    if (validateForm()) {
      final mapDAta = useRCV.toMap();
      final formData = FormData.fromMap(mapDAta);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          use = Use.fromMap(response.data);
          getUses();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future<bool?> editUse(String id, Use useRCV) async {
    if (validateForm()) {
      final mapDAta = useRCV.toMap();
      final formData = FormData.fromMap(mapDAta);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          use = Use.fromMap(response.data);
          getUses();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deleteUse(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        uses.removeWhere((use) => use['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteUses(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        uses.removeWhere((use) => ids.contains(use['id'].toString()));
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
        uses = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }
}
