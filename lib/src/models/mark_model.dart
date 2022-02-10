// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

class Mark {
  Mark({
    this.id,
    this.created,
    this.updated,
    this.code,
    this.description,
    this.isActive,
  }) {
    isActive = isActive ?? true;
  }

  String? id;
  DateTime? created;
  DateTime? updated;
  String? code;
  String? description;
  bool? isActive;

  factory Mark.fromJson(String str) => Mark.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mark.fromMap(Map<String, dynamic> json) => Mark(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        code: json["code"],
        description: json["description"],
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'created': created?.millisecondsSinceEpoch,
        'updated': updated?.millisecondsSinceEpoch,
        "code": code,
        "description": description,
        "is_active": isActive,
      };
}
