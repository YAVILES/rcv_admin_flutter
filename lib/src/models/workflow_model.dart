import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/module_model.dart';

class Workflow {
  Workflow({
    this.id = '',
    this.created,
    this.updated,
    this.title = '',
    this.url = '',
    this.icon = '',
    this.module = '',
    this.moduleDisplay,
  });

  String? id;
  DateTime? created;
  DateTime? updated;
  String? title;
  String? url;
  String? icon;
  String? module;
  Module? moduleDisplay;

  factory Workflow.fromJson(String str) => Workflow.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Workflow.fromMap(Map<String, dynamic> json) => Workflow(
        id: json["id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        updated:
            json["updated"] == null ? null : DateTime.parse(json["updated"]),
        title: json["title"],
        url: json["url"],
        icon: json["icon"],
        module: json["module"],
        moduleDisplay: json["module"] == null
            ? null
            : Module.fromMap(json["module_display"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "title": title,
        "url": url,
        "icon": icon,
        "module": module,
        "module_display": moduleDisplay?.toMap()
      };
}
