// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/coverage_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';

class PolicyItem {
  PolicyItem({
    this.id,
    this.number,
    this.cost,
    this.insuredAmount,
    this.coverage,
    this.coverageDisplay,
    this.policy,
    this.policyDisplay,
  });

  String? id;
  int? number;
  String? coverage;
  Coverage? coverageDisplay;
  String? policy;
  Policy? policyDisplay;
  double? insuredAmount;
  double? cost;

  factory PolicyItem.fromJson(String str) =>
      PolicyItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PolicyItem.fromMap(Map<String, dynamic> json) => PolicyItem(
        id: json["id"],
        number: json["number"],
        coverage: json["coverage"],
        coverageDisplay: json["coverage_display"] == null
            ? null
            : Coverage.fromMap(json["coverage_display"]),
        policy: json["policy"],
        policyDisplay: json["policy_display"] == null
            ? null
            : Policy.fromMap(json["policy_display"]),
        cost: json["cost"] == null ? null : double.parse(json["cost"]),
        insuredAmount: json["insured_amount"] == null
            ? null
            : double.parse(json["insured_amount"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "number": number,
        "coverage": coverage,
        "coverage_display": coverageDisplay?.toMap(),
        "policy": policy,
        "policy_display": policyDisplay?.toMap(),
        "cost": cost,
        "insured_amount": insuredAmount,
      };

  Map<String, dynamic> toMapSave() => {
        "coverage": coverage,
        "policy": policy,
        "cost": cost,
        "insured_amount": insuredAmount,
      };
}
