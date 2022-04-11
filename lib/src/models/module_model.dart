import 'dart:convert';

class Module {
  Module(
      {this.id = '',
      this.created,
      this.updated,
      this.title = '',
      this.icon = ''});

  String? id;
  DateTime? created;
  DateTime? updated;
  String? title;
  String? icon;

  factory Module.fromJson(String str) => Module.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Module.fromMap(Map<String, dynamic> json) => Module(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        title: json["title"],
        icon: json["icon"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "title": title,
        "icon": icon
      };
}
