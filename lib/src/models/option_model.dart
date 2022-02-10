// To parse this JSON data, do
//
//     final branchOffice = branchOfficeFromMap(jsonString);

import 'dart:convert';

class Option {
  Option({
    this.value,
    this.description,
  });

  String? value;
  String? description;

  factory Option.fromJson(String str) => Option.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Option.fromMap(Map<String, dynamic> json) => Option(
        value: json["value"].toString(),
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "description": description,
      };
}
