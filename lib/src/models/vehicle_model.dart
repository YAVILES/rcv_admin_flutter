// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
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
    this.year,
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
    this.ownerIdentityCardImage,
    this.ownerLicense,
    this.ownerCirculationCard,
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
  String? year;
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

  String? ownerIdentityCardImage;
  String? ownerLicense;
  String? ownerCirculationCard;

  PlatformFile? ownerIdentityCardImageFile;
  PlatformFile? ownerLicenseFile;
  PlatformFile? ownerCirculationCardFile;
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
        year: json["year"],
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
        ownerIdentityCardImage: json["owner_identity_card_image"],
        ownerLicense: json["owner_license"],
        ownerCirculationCard: json["owner_circulation_card"],
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
        "year": year,
        "use_display": useDisplay?.toMap(),
        "model": model,
        "model_display": modelDisplay?.toMap(),
        "transmission": transmission,
        "transmission_display": transmissionDisplay,
        "taker": taker,
        "taker_display": takerDisplay?.toMap(),
        "owner_name": ownerName,
        "owner_last_name": ownerLastName,
        "owner_address": ownerAddress,
        "owner_identity_card": ownerIdentityCard,
        "owner_email": ownerEmail,
        "owner_phones": ownerPhones,
        "owner_identity_card_image": ownerIdentityCardImage,
        "owner_license": ownerLicense,
        "owner_circulation_card": ownerCirculationCard,
        "is_active": isActive,
      };

  Map<String, dynamic> toMapSave() => {
        "serial_bodywork": serialBodywork,
        "serial_engine": serialEngine,
        "license_plate": licensePlate,
        "stalls": stalls,
        "color": color,
        "use": use,
        "model": model,
        "transmission": transmission,
        "taker": taker,
        "year": year,
        "owner_name": ownerName,
        "owner_last_name": ownerLastName,
        "owner_address": ownerAddress,
        "owner_email": ownerEmail,
        "owner_phones": ownerPhones,
        "is_active": isActive,
      };
}
