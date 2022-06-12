// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_item_model.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';

class Policy {
  Policy({
    this.id,
    this.number,
    this.created,
    this.updated,
    this.taker,
    this.takerDisplay,
    this.adviser,
    this.adviserDisplay,
    this.createdBy,
    this.createdByDisplay,
    this.vehicle,
    this.vehicleDisplay,
    this.plan,
    this.planDisplay,
    this.coverage,
    this.items,
    this.type,
    this.typeDisplay,
    this.action,
    this.actionDisplay,
    this.dueDate,
    this.status,
    this.statusDisplay,
    this.totalAmount,
    this.totalAmountDisplay,
    this.totalInsuredAmount,
    this.totalInsuredAmountDisplay,
    this.changeFactor,
  });

  String? id;
  int? number;
  DateTime? created;
  DateTime? updated;
  String? taker;
  User? takerDisplay;
  String? adviser;
  User? adviserDisplay;
  String? createdBy;
  User? createdByDisplay;
  String? vehicle;
  Vehicle? vehicleDisplay;
  String? plan;
  Plan? planDisplay;
  List<String>? coverage;
  List<PolicyItem>? items;
  int? type;
  String? typeDisplay;
  int? action;
  String? actionDisplay;
  DateTime? dueDate;
  int? status;
  String? statusDisplay;
  double? totalAmount;
  double? totalInsuredAmount;
  String? totalAmountDisplay;
  String? totalInsuredAmountDisplay;
  double? changeFactor;

  factory Policy.fromJson(String str) => Policy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Policy.fromMap(Map<String?, dynamic> json) => Policy(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        number: json["number"],
        taker: json["taker"],
        takerDisplay: json["taker_display"] == null
            ? null
            : User.fromMap(json["taker_display"]),
        adviser: json["adviser"],
        adviserDisplay: json["adviser_display"] == null
            ? null
            : User.fromMap(json["adviser_display"]),
        createdBy: json["created_by"],
        createdByDisplay: json["created_by_display"] == null
            ? null
            : User.fromMap(json["created_by_display"]),
        vehicle: json["vehicle"],
        vehicleDisplay: json["vehicle_display"] == null
            ? null
            : Vehicle.fromMap(json["vehicle_display"]),
        plan: json["plan"],
        planDisplay: json["plan_display"] == null
            ? null
            : Plan.fromMap(json["plan_display"]),
        coverage: json["coverage"] == null
            ? []
            : List<String>.from(json["coverage"].map((x) => x)),
        items: json["items"] == null
            ? []
            : List<PolicyItem>.from(
                json["items"].map((x) => PolicyItem.fromMap(x))),
        type: json["type"],
        typeDisplay: json["type_display"],
        action: json["action"],
        actionDisplay: json["action_display"],
        status: json["status"],
        statusDisplay: json["status_display"],
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        totalAmount: json["total_amount"] == null
            ? null
            : double.parse(json["total_amount"]),
        totalAmountDisplay: json["total_amount_display"],
        totalInsuredAmount: json["total_insured_amount"] == null
            ? null
            : double.parse(json["total_insured_amount"]),
        totalInsuredAmountDisplay: json["total_insured_amount_display"],
        changeFactor: json["change_factor"] == null
            ? null
            : double.parse(json["change_factor"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "number": number,
        "taker": taker,
        "taker_display": takerDisplay?.toMap(),
        "adviser": adviser,
        "adviser_display": adviserDisplay?.toMap(),
        "vehicle": vehicle,
        "vehicle_display": vehicleDisplay?.toMap(),
        "created_by": createdBy,
        "created_by_display": createdByDisplay?.toMap(),
        "plan": plan,
        "plan_display": planDisplay?.toMap(),
        "coverage": coverage == null
            ? []
            : List<String>.from(coverage!.map((x) => x.toString())),
        "items": items == null
            ? []
            : List<Map<String, dynamic>>.from(items!.map((x) => x.toMap())),
        "type": type,
        "action": action,
        "type_display": typeDisplay,
        "action_display": actionDisplay,
        "due_date": dueDate?.millisecondsSinceEpoch,
        "status": status,
        "status_display": statusDisplay,
        "total_amount": totalAmount,
        "total_amount_display": totalAmountDisplay,
        "total_insured_amount": totalInsuredAmount,
        "total_insured_amount_display": totalInsuredAmountDisplay,
        "change_factor": changeFactor,
      };

  Map<String, dynamic> toMapSave() => {
        "taker": taker,
        "vehicle": vehicle,
        "type": type,
        "plan": plan,
        "coverage": coverage == null
            ? []
            : List<String>.from(coverage!.map((x) => x.toString())),
      };
}
