// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/model_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';

class Vehicle {
  Vehicle({
    this.id,
    this.created,
    this.updated,
    this.serialBodywork,
    this.serialEngine,
    this.licensePlate,
    this.stalls,
    this.color,
    this.use,
    this.useDisplay,
    this.model,
    this.modelDisplay,
    this.transmission,
    this.transmissionDisplay,
    this.taker,
    this.takerDisplay,
    this.ownerName,
    this.ownerLastName,
    this.ownerIdentityCard,
    this.ownerPhones,
    this.ownerAddress,
    this.ownerEmail,
    this.isActive,
  }) {
    isActive = isActive ?? true;
    stalls = stalls ?? 4;
  }

  String? id;
  DateTime? created;
  DateTime? updated;
  String? serialBodywork;
  String? serialEngine;
  String? licensePlate;
  int? stalls;
  String? color;
  String? use;
  Use? useDisplay;
  String? model;
  Model? modelDisplay;
  String? taker;
  User? takerDisplay;
  int? transmission;
  String? transmissionDisplay;
  String? ownerName;
  String? ownerLastName;
  String? ownerIdentityCard;
  String? ownerPhones;
  String? ownerAddress;
  String? ownerEmail;
  bool? isActive;

  factory Vehicle.fromJson(String str) => Vehicle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Vehicle.fromMap(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        serialBodywork: json["serial_bodywork"],
        serialEngine: json["serial_engine"],
        licensePlate: json["license_plate"],
        stalls: json["stalls"],
        color: json["color"],
        use: json["use"],
        useDisplay: json["use_display"] == null
            ? null
            : Use.fromMap(json["use_display"]),
        model: json["model"],
        modelDisplay: json["model_display"] == null
            ? null
            : Model.fromMap(json["model_display"]),
        transmission: json["transmission"] ?? 1,
        transmissionDisplay: json["transmission_display"],
        taker: json["taker"],
        takerDisplay: json["taker_display"] == null
            ? null
            : User.fromMap(json["taker_display"]),
        ownerName: json["owner_name"],
        ownerLastName: json["owner_last_name"],
        ownerAddress: json["owner_address"],
        ownerIdentityCard: json["owner_identity_card"],
        ownerEmail: json["owner_email"],
        ownerPhones: json["owner_phones"],
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'created': created?.millisecondsSinceEpoch,
        'updated': updated?.millisecondsSinceEpoch,
        "serial_bodywork": serialBodywork,
        "serial_engine": serialEngine,
        "license_plate": licensePlate,
        "stalls": stalls,
        "color": color,
        "use": use,
        "use_display": useDisplay?.toMap(),
        "model": model,
        "model_display": modelDisplay?.toMap(),
        "transmission": transmission,
        "transmission_display": transmissionDisplay,
        "taker": taker,
        "taker_dispaly": takerDisplay?.toMap(),
        "owner_name": ownerName,
        "owner_last_name": ownerLastName,
        "owner_address": ownerAddress,
        "owner_identity_card": ownerIdentityCard,
        "owner_email": ownerEmail,
        "owner_phones": ownerPhones,
        "is_active": isActive,
      };
}
