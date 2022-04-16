// To parse this JSON data, do
//
//     final premium = premiumFromMap(jsonString);

import "dart:convert";

import "package:rcv_admin_flutter/src/models/coverage_model.dart";
import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import "package:rcv_admin_flutter/src/models/use_model.dart";

class Premium {
  Premium({
    this.id,
    this.coverage,
    this.use,
    this.plan,
    this.coverageDisplay,
    this.useDisplay,
    this.planDisplay,
    this.created,
    this.updated,
    this.insuredAmount,
    this.insuredAmountDisplay,
    this.cost,
    this.costDisplay,
  });

  String? id;
  String? coverage;
  String? use;
  String? plan;
  double? insuredAmount;
  double? cost;
  String? insuredAmountDisplay;
  String? costDisplay;
  Coverage? coverageDisplay;
  Use? useDisplay;
  Plan? planDisplay;
  DateTime? created;
  DateTime? updated;

  factory Premium.fromJson(String str) => Premium.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Premium.fromMap(Map<String, dynamic> json) => Premium(
      id: json["id"],
      coverage: json["coverage"],
      use: json["use"],
      plan: json["plan"],
      coverageDisplay: json["coverage_display"] == null
          ? null
          : Coverage.fromMap(json["coverage_display"]),
      useDisplay:
          json["use_display"] == null ? null : Use.fromMap(json["use_display"]),
      planDisplay: json["plan_display"] == null
          ? null
          : Plan.fromMap(json["plan_display"]),
      insuredAmount: json["insured_amount"] == null
          ? null
          : double.parse(json["insured_amount"].toString()),
      cost: json["cost"] == null ? null : double.parse(json["cost"].toString()),
      costDisplay: json['cost_display'],
      insuredAmountDisplay: json['insured_amount_display']
      /* created:
            json["created"] != null ? DateTime.parse(json["created"]) : null,
        updated:
            json["updated"] != null ? DateTime.parse(json["updated"]) : null, */
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "coverage": coverage,
        "use": use,
        "plan": plan,
        "plan_display": planDisplay?.toMap(),
        "coverage_display": coverageDisplay?.toMap(),
        "use_display": useDisplay?.toMap(),
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "insured_amount": insuredAmount,
        "insured_amount_display": insuredAmountDisplay,
        "cost": cost,
        "cost_display": costDisplay,
      };
}
