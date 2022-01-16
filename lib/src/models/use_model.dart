import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/premium_model.dart';

class Use {
  Use({
    this.id,
    this.created,
    this.updated,
    this.code,
    this.description,
    this.isActive = true,
    this.premiums,
  });

  String? id;
  DateTime? created;
  DateTime? updated;
  String? code;
  String? description;
  bool? isActive = true;
  List<Premium>? premiums;

  factory Use.fromJson(String str) => Use.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Use.fromMap(Map<String, dynamic> json) => Use(
        id: json["id"],
        created:
            json['created'] != null ? DateTime.parse(json["created"]) : null,
        updated:
            json['updated'] != null ? DateTime.parse(json["updated"]) : null,
        code: json["code"],
        description: json["description"],
        premiums: json["premiums"] != null
            ? List<Premium>.from(
                json["premiums"].map((x) => Premium.fromMap(x)))
            : null,
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "code": code,
        "description": description,
        "premiums": premiums == null
            ? []
            : List<Map<String, dynamic>>.from(premiums!.map((x) => x.toMap())),
        "is_active": isActive,
      };
}
