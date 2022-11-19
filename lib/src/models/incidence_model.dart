// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';

class Incidence {
  Incidence({
    this.id,
    this.created,
    this.updated,
    this.vehicle,
    this.vehicleDisplay,
    this.policy,
    this.policyDisplay,
    this.amount,
    this.detail,
  });

  String? id;
  DateTime? created;
  DateTime? updated;

  String? vehicle;
  Vehicle? vehicleDisplay;
  String? policy;
  Policy? policyDisplay;
  String? detail;
  double? amount;

  factory Incidence.fromJson(String str) => Incidence.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Incidence.fromMap(Map<String?, dynamic> json) => Incidence(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        vehicle: json["vehicle"],
        vehicleDisplay: json["vehicle_display"] == null
            ? null
            : Vehicle.fromMap(json["vehicle_display"]),
        policy: json["policy"],
        policyDisplay: json["policy_display"] == null
            ? null
            : Policy.fromMap(json["policy_display"]),
        detail: json["detail"],
        amount: json["amount"] == null ? null : double.parse(json["amount"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "vehicle": vehicle,
        "vehicle_display": vehicleDisplay?.toMap(),
        "policy": policy,
        "policy_display": policyDisplay?.toMap(),
        "detail": detail,
        "amount": amount,
      };

  Map<String, dynamic> toMapSave() => {
        "vehicle": vehicle,
        "detail": detail,
        "policy": policy,
        "amount": amount,
      };
}
