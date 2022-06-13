// To parse this JSON data, do
//
//     final banner = bannerFromMap(jsonString);

import 'dart:convert';

class Section {
  Section({
    this.id,
    this.created,
    this.updated,
    this.title,
    this.type,
    this.typeDisplay,
    this.subtitle,
    this.content,
    this.imageDisplay,
    this.shapeDisplay,
    this.iconDisplay,
    this.url,
    this.sequenceOrder,
    this.isActive,
  }) {
    sequenceOrder = sequenceOrder ?? 1;
    isActive = isActive ?? true;
  }

  String? id;
  DateTime? created;
  DateTime? updated;
  String? title;
  String? subtitle;
  String? content;
  String? type;
  String? typeDisplay;
  String? imageDisplay;
  String? shapeDisplay;
  String? iconDisplay;
  String? url;
  int? sequenceOrder;
  bool? isActive;

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());
  String toJson() => 'Section $title';
  factory Section.fromMap(Map<String, dynamic> json) => Section(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        title: json["title"],
        subtitle: json["subtitle"],
        content: json["content"],
        imageDisplay: json["image_display"],
        shapeDisplay: json["shape_display"],
        iconDisplay: json["icon_display"],
        url: json["url"],
        type: json["type"],
        typeDisplay: json["type_display"],
        sequenceOrder: json["sequence_order"],
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
        "title": title,
        "subtitle": subtitle,
        "content": content,
        "image_display": imageDisplay,
        "shape_display": shapeDisplay,
        "icon_display": iconDisplay,
        "type_display": typeDisplay,
        "url": url,
        "type": type,
        "sequence_order": sequenceOrder,
        "is_active": isActive,
      };
}
