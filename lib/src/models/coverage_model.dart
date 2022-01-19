// To parse this JSON data, do
//
//     final coverage = coverageFromMap(jsonString);

import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';

class Coverage {
  Coverage({
    this.id,
    this.code,
    this.description,
    this.plans,
    this.plansDisplay,
    this.coverageDefault,
    this.isActive,
    this.premium,
  });

  String? id;
  String? code;
  String? description;
  List<String>? plans = [];
  List<Plan>? plansDisplay = [];
  bool? coverageDefault = false;
  bool? isActive;
  Premium? premium;

  factory Coverage.fromJson(String str) => Coverage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Coverage.fromMap(Map<String, dynamic> json) => Coverage(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        coverageDefault: json["default"] ?? false,
        plans: json["plans"] == null ? [] : List<String>.from(json["plans"]),
        premium:
            json["premium"] == null ? null : Premium.fromMap(json["premium"]),
        plansDisplay: json['plans_display'] != null
            ? List<Plan>.from(
                json['plans_display']?.map((x) => Plan.fromMap(x)))
            : null,
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "code": code,
        "description": description,
        "default": coverageDefault,
        'plans': plans,
        'premium': premium != null ? premium!.toMap() : null,
        'plans_display': plansDisplay?.map((x) => x.toMap()).toList(),
        "is_active": isActive,
      };
}
