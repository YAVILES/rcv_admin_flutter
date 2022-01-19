import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PlanService {
  static String url = '/core/plan';

  static Future<Plan?> getPlanPerUse(String planId, String useId) async {
    Plan plan;
    try {
      final response = await API.get('$url/$planId/?use=$useId');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        plan = Plan.fromMap(data);
        return plan;
      }
      return null;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<List<Plan>> getPlans(Map<String, dynamic>? params) async {
    List<Plan> plans = [];
    try {
      final response = await API.list('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        plans = data.map((w) => Plan.fromMap(w)).toList();
      }
      return plans;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Stream<PlansUses> getPlansAndUses(
      {Map<String, dynamic>? paramsPlans,
      Map<String, dynamic>? paramsUses}) async* {
    List<Map<String, dynamic>> plans = [];
    List<Map<String, dynamic>> uses = [];
    try {
      final responsePlans = await API.list('$url/', params: paramsPlans);
      if (responsePlans.statusCode == 200) {
        plans = List<Map<String, dynamic>>.from(responsePlans.data);
      }
      final responseUses = await API.list('/core/use/', params: paramsUses);
      if (responseUses.statusCode == 200) {
        uses = List<Map<String, dynamic>>.from(responseUses.data);
      }
      yield PlansUses.fromMap({'plans': plans, 'uses': uses});
    } on ErrorAPI {
      rethrow;
    }
  }
}

class PlansUses {
  List<Plan>? plans;
  List<Use>? uses;
  PlansUses({
    this.plans,
    this.uses,
  });

  Map<String, dynamic> toMap() {
    return {
      'plans': plans?.map((x) => x.toMap()).toList(),
      'uses': uses?.map((x) => x.toMap()).toList(),
    };
  }

  factory PlansUses.fromMap(Map<String, dynamic> map) {
    return PlansUses(
      plans: map['plans'] != null
          ? List<Plan>.from(map['plans']?.map((x) => Plan.fromMap(x)))
          : null,
      uses: map['uses'] != null
          ? List<Use>.from(map['uses']?.map((x) => Use.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlansUses.fromJson(String source) =>
      PlansUses.fromMap(json.decode(source));
}
