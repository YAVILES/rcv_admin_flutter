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
    this.email,
    this.direction,
    this.telephone,
    this.linkGoogleMaps,
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
  String? email;
  String? direction;
  String? telephone;
  String? linkGoogleMaps;
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
        email: json["email"],
        direction: json["direction"],
        telephone: json["telephone"],
        linkGoogleMaps: json["link_google_maps"],
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        'created': created?.millisecondsSinceEpoch,
        'updated': updated?.millisecondsSinceEpoch,
        "number": number,
        "code": code,
        "description": description,
        "email": email,
        "direction": direction,
        "telephone": telephone,
        "link_google_maps": linkGoogleMaps,
        "is_active": isActive,
      };
}
