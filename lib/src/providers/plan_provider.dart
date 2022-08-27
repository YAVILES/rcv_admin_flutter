import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/coverage_model.dart';
import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PlanProvider with ChangeNotifier {
  String url = '/core/plan';
  List<Map<String, dynamic>> plans = [];
  Plan? plan;
  bool loading = false;
  Use? use;
  List<Coverage>? coverage;
  late GlobalKey<FormState> formPlanKey;

  String? searchValue;

  bool validateForm() {
    return formPlanKey.currentState!.validate();
  }

  Future getPlans() async {
    loading = true;
    notifyListeners();

    try {
      final response = await PlanService.getPlans({
        'not_paginator': true,
        'query': '{id, code, description, uses_display {id, description}}'
      });
      plans = response.map((e) => e.toMap()).toList();
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  Future<Plan?> getPlan(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Plan.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newPlan(Plan planRCV) async {
    if (validateForm()) {
      final mapDAta = planRCV.toMap();
      try {
        final response = await API.add('$url/', mapDAta);
        if (response.statusCode == 200 || response.statusCode == 201) {
          plan = Plan.fromMap(response.data);
          getPlans();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future<bool?> editPlan(String id, Plan planRCV) async {
    if (validateForm()) {
      final mapDAta = planRCV.toMap();
      try {
        final response = await API.put('$url/$id/', mapDAta);
        if (response.statusCode == 200 || response.statusCode == 201) {
          plan = Plan.fromMap(response.data);
          getPlans();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deletePlan(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        plans.removeWhere((plan) => plan['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deletePlans(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        plans.removeWhere((plan) => ids.contains(plan['id'].toString()));
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
        plans = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  notifyUse(Use? _use) {
    use = _use;
    notifyListeners();
  }
}
