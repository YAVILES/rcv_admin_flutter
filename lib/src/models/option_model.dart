// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

class Option {
  Option({
    this.code,
    this.description,
  });

  String? code;
  String? description;

  factory Option.fromJson(String str) => Option.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Option.fromMap(Map<String, dynamic> json) => Option(
        code: json["code"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "description": description,
      };
}
