import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PremiumProvider with ChangeNotifier {
  String url = '/core/premium';
  List<Premium> premiums = [];
  Premium? premium;
  bool loading = false;

  late GlobalKey<FormState> formPremiumKey;

  String? searchValue;

  bool validateForm() {
    return formPremiumKey.currentState!.validate();
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
        premiums
            .removeWhere((premium) => premium.id.toString() == id.toString());
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
        premiums.removeWhere((premium) => ids.contains(premium.id.toString()));
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  void definePremium(Premium premium) {
    if (premiums
        .where((element) =>
            element.use == premium.use &&
            element.coverage == premium.coverage &&
            element.plan == premium.plan)
        .isEmpty) {
      premiums.add(premium);
    } else {
      premiums = premiums.map((element) {
        if (element.use == premium.use &&
            element.coverage == premium.coverage &&
            element.plan == premium.plan) {
          element.insuredAmount = premium.insuredAmount;
          element.cost = premium.cost;
        }
        return element;
      }).toList();
    }
  }

  void defineinsuredAmount(String coverageId, double insuredAmount) {
    int index =
        premiums.indexWhere((element) => element.coverage == coverageId);
    if (index >= 0) {
      premiums[index].insuredAmount = insuredAmount;
    }
  }

  void defineCost(String coverageId, double cost) {
    int index =
        premiums.indexWhere((element) => element.coverage == coverageId);
    if (index >= 0) {
      premiums[index].cost = cost;
    }
  }

  Stream<PlansUses> getPlansAndUses(
      {Map<String, dynamic>? paramsPlans,
      Map<String, dynamic>? paramsUses}) async* {
    loading = true;
    notifyListeners();
    List<Map<String, dynamic>> plans = [];
    List<Map<String, dynamic>> uses = [];
    try {
      final responsePlans = await API.get('/core/plan/', params: paramsPlans);
      if (responsePlans.statusCode == 200) {
        plans = List<Map<String, dynamic>>.from(responsePlans.data);
      }
      final responseUses = await API.get('/core/use/', params: paramsUses);
      if (responseUses.statusCode == 200) {
        uses = List<Map<String, dynamic>>.from(responseUses.data);
      }
      yield PlansUses.fromMap({'plans': plans, 'uses': uses});
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      rethrow;
    }
  }

  notify() {
    notifyListeners();
  }
}
