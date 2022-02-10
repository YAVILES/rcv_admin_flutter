// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/mark_model.dart';

class Model {
  Model({
    this.id,
    this.created,
    this.updated,
    this.code,
    this.description,
    this.mark,
    this.markDisplay,
    this.isActive,
  }) {
    isActive = isActive ?? true;
  }

  String? id;
  DateTime? created;
  DateTime? updated;
  String? code;
  String? description;
  Mark? markDisplay;
  String? mark;
  bool? isActive;

  factory Model.fromJson(String str) => Model.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Model.fromMap(Map<String, dynamic> json) => Model(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        code: json["code"],
        description: json["description"],
        mark: json["mark"],
        markDisplay: json["mark_display"] == null
            ? null
            : Mark.fromMap(json["mark_display"]),
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'created': created?.millisecondsSinceEpoch,
        'updated': updated?.millisecondsSinceEpoch,
        "code": code,
        "description": description,
        "mark": mark,
        "mark_display": markDisplay?.toMap(),
        "is_active": isActive,
      };
}
