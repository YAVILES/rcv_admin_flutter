// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

import 'package:file_picker/file_picker.dart';

class Bank {
  Bank({
    this.id,
    this.created,
    this.updated,
    this.code,
    this.description,
    this.email,
    this.accountName,
    this.accountNumber,
    this.methods,
    this.coins,
    this.status,
    this.statusDisplay,
    this.image,
    this.imageDisplay,
  });

  String? id;
  DateTime? created;
  DateTime? updated;
  String? code;
  String? description;
  String? email;
  String? accountNumber;
  String? accountName;
  List<int>? methods;
  List<String>? coins;
  int? status;
  String? statusDisplay;
  PlatformFile? image;
  String? imageDisplay;

  factory Bank.fromJson(String str) => Bank.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Bank.fromMap(Map<String, dynamic> json) => Bank(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        code: json["code"],
        description: json["description"],
        email: json["email"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
        methods: json["methods"] == null ? [] : List<int>.from(json["methods"]),
        coins: json["coins"] == null ? [] : List<String>.from(json["coins"]),
        status: json["status"] ?? 1,
        statusDisplay: json["status_display"],
        imageDisplay: json["image_display"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'created': created?.millisecondsSinceEpoch,
        'updated': updated?.millisecondsSinceEpoch,
        "code": code,
        "description": description,
        "email": email,
        "account_name": accountName,
        "account_number": accountNumber,
        "methods": methods,
        "coins": coins,
        "status": status,
        "status_display": statusDisplay,
        "image_display": imageDisplay,
      };
}
