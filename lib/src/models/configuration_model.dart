import 'dart:convert';

class Configuration {
  int? id;
  String? key;
  dynamic defaultValue;
  String? helpText;
  dynamic value;

  Configuration({
    this.id,
    this.key,
    this.defaultValue,
    this.helpText,
    this.value,
  });

  factory Configuration.fromJson(String str) =>
      Configuration.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Configuration.fromMap(Map<String, dynamic> json) {
    return Configuration(
      id: int.parse(json["id"]),
      key: json["key"],
      defaultValue: json["default"],
      helpText: json["help_text"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "key": key,
        "default": defaultValue,
        "helpText": helpText,
        "value": value,
      };
}
