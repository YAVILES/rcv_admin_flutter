import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/use_model.dart';

import 'coverage_model.dart';

class Plan {
  Plan({
    this.id,
    this.uses,
    this.usesDisplay,
    this.coverage,
    this.created,
    this.updated,
    this.code,
    this.description,
    this.costTotal = 0,
    this.costTotalDisplay,
    this.insuredAmountTotal = 0,
    this.insuredAmountTotalDisplay,
    this.isActive = true,
  });

  String? id;
  List<String>? uses = [];
  List<Use>? usesDisplay = [];
  List<Coverage>? coverage = [];
  DateTime? created;
  DateTime? updated;
  String? code;
  String? description;
  String? costTotalDisplay;
  double? costTotal;
  String? insuredAmountTotalDisplay;
  double? insuredAmountTotal;
  bool? isActive;

  factory Plan.fromJson(String str) => Plan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Plan.fromMap(Map<String?, dynamic> json) => Plan(
        id: json["id"],
        uses: json["uses"] == null
            ? []
            : List<String>.from(json["uses"].map((x) => x)),
        usesDisplay: json["uses_display"] == null
            ? []
            : List<Use>.from(json["uses_display"].map((x) => Use.fromMap(x))),
        coverage: json["coverage"] == null
            ? []
            : List<Coverage>.from(
                json["coverage"].map((x) => Coverage.fromMap(x))),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        code: json["code"],
        description: json["description"],
        costTotal: json["cost_total"] == null
            ? null
            : double.parse(json["cost_total"].toString()),
        costTotalDisplay: json["cost_total_display"],
        insuredAmountTotal: json["insured_amount_total"] == null
            ? null
            : double.parse(json["insured_amount_total"].toString()),
        insuredAmountTotalDisplay: json["insured_amount_total_display"],
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "uses": uses == null
            ? []
            : List<String>.from(uses!.map((x) => x.toString())),
        "uses_display": usesDisplay == null
            ? []
            : List<Map<String, dynamic>>.from(
                usesDisplay!.map((x) => x.toMap())),
        "coverage": coverage == null
            ? []
            : List<Map<String, dynamic>>.from(coverage!.map((x) => x.toMap())),
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "code": code,
        "description": description,
        "cost_total_display": costTotalDisplay,
        "cost_total": costTotal,
        "insured_amount_total": insuredAmountTotal,
        "insured_amount_total_display": insuredAmountTotalDisplay,
        "is_active": isActive,
      };
}
