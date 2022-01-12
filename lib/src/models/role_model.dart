// To parse this JSON data, do
//
//     final role = roleFromMap(jsonString);

import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/workflow_model.dart';

class Role {
  Role({
    this.id,
    this.workflows,
    this.workflowsDisplay,
    this.name = '',
    this.isActive = true,
  });

  int? id;
  List<Workflow>? workflowsDisplay = [];
  List<String>? workflows = [];
  String? name;
  bool? isActive;

  factory Role.fromJson(String str) => Role.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Role.fromMap(Map<String, dynamic> json) => Role(
        id: json["id"] == null ? null : int.parse(json["id"].toString()),
        workflows: json["workflows"] == null
            ? []
            : List<String>.from(json["workflows"]),
        workflowsDisplay: json["workflows_display"] == null
            ? []
            : List<Workflow>.from(
                json["workflows_display"].map((x) => Workflow.fromMap(x))),
        name: json["name"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "workflows": workflows ?? [],
        "workflows_display": workflowsDisplay == null
            ? []
            : List<dynamic>.from(workflowsDisplay!.map((x) => x.toMap())),
        "name": name,
        "is_active": isActive,
      };
}
