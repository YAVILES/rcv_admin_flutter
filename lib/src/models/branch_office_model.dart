// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

class BranchOffice {
  BranchOffice({
    this.id,
    this.created,
    this.updated,
    this.number,
    this.code,
    this.description,
    this.isActive,
  }) {
    isActive = isActive ?? true;
  }

  String? id;
  DateTime? created;
  DateTime? updated;
  int? number;
  String? code;
  String? description;
  bool? isActive;

  factory BranchOffice.fromJson(String str) =>
      BranchOffice.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BranchOffice.fromMap(Map<String, dynamic> json) => BranchOffice(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        number: json["number"] != null
            ? int.parse(json["number"].toString())
            : null,
        code: json["code"],
        description: json["description"],
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'created': created?.millisecondsSinceEpoch,
        'updated': updated?.millisecondsSinceEpoch,
        "number": number,
        "code": code,
        "description": description,
        "is_active": isActive,
      };
}
