import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PremiumProvider with ChangeNotifier {
  String url = '/core/premium';
  List<Map<String, dynamic>> premiums = [];
  Premium? premium;
  bool loading = false;

  late GlobalKey<FormState> formPremiumKey;

  String? searchValue;

  bool validateForm() {
    return formPremiumKey.currentState!.validate();
  }

  Future getPremiums() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        premiums = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<Premium?> getPremium(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Premium.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newPremium(Premium premiumRCV) async {
    if (validateForm()) {
      final mapDAta = premiumRCV.toMap();
      final formData = FormData.fromMap(mapDAta);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          premium = Premium.fromMap(response.data);
          getPremiums();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future<bool?> editPremium(String id, Premium premiumRCV) async {
    if (validateForm()) {
      final mapDAta = premiumRCV.toMap();
      final formData = FormData.fromMap(mapDAta);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          premium = Premium.fromMap(response.data);
          getPremiums();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deletePremium(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        premiums.removeWhere(
            (premium) => premium['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deletePremiums(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        premiums
            .removeWhere((premium) => ids.contains(premium['id'].toString()));
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
        premiums = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }
}
