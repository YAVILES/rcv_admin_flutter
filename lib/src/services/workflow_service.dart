import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/workflow_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class WorkFlowService {
  static String url = '/security/workflow';
  static Future<List<Workflow>> getWorkFlows(
      Map<String, dynamic>? params) async {
    List<Workflow> workflows = [];
    try {
      final response = await API.list('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        workflows = data.map((w) => Workflow.fromMap(w)).toList();
      }
      return workflows;
    } on ErrorAPI {
      rethrow;
    }
  }

  static IconData iconDataMenuWorkflow(String key) {
    late IconData icon;
    switch (key) {
      case "system_update_outlined":
        icon = Icons.system_update_outlined;
        break;
      case "accessibility_rounded":
        icon = Icons.accessibility_rounded;
        break;
      case "supervised_user_circle_rounded":
        icon = Icons.supervised_user_circle_rounded;
        break;
      case "location_city_outlined":
        icon = Icons.location_city_outlined;
        break;
      case "verified_outlined":
        icon = Icons.verified_outlined;
        break;
      case "local_convenience_store_sharp":
        icon = Icons.local_convenience_store_sharp;
        break;
      case "local_offer_outlined":
        icon = Icons.local_offer_outlined;
        break;
      case "supervised_user_circle_outlined":
        icon = Icons.supervised_user_circle_outlined;
        break;
      case "nature":
        icon = Icons.nature;
        break;
      case "car_rental_outlined":
        icon = Icons.car_rental_outlined;
        break;
      case "image_outlined":
        icon = Icons.image_outlined;
        break;
      case "model_training_outlined":
        icon = Icons.model_training_outlined;
        break;
      case "car_repair_outlined":
        icon = Icons.car_repair_outlined;
        break;
      case "settings_display":
        icon = Icons.settings_display;
        break;
      case "price_change_outlined":
        icon = Icons.price_change_outlined;
        break;
      case "security_update_good_outlined":
        icon = Icons.security_update_good_outlined;
        break;
      case "supervisor_account":
        icon = Icons.supervisor_account;
        break;
      case "payment_outlined":
        icon = Icons.payment_outlined;
        break;
      case "payment_rounded":
        icon = Icons.payment_rounded;
        break;
      case "food_bank_outlined":
        icon = Icons.food_bank_outlined;
        break;
      case "home_repair_service_outlined":
        icon = Icons.home_repair_service_outlined;
        break;
      case "rule_outlined":
        icon = Icons.rule_outlined;
        break;
      default:
        icon = Icons.nature;
    }
    return icon;
  }
}
