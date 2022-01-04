// To parse this JSON data, do
//
//     final banner = bannerFromMap(jsonString);

import 'dart:convert';

class BannerRCV {
  BannerRCV({
    this.id,
    this.created,
    this.updated,
    this.title,
    this.subtitle,
    this.content,
    this.image,
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
  String? image;
  String? url;
  int? sequenceOrder;
  bool? isActive;

  factory BannerRCV.fromJson(String str) => BannerRCV.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());
  String toJson() => 'Banner $title';
  factory BannerRCV.fromMap(Map<String, dynamic> json) => BannerRCV(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        title: json["title"],
        subtitle: json["subtitle"],
        content: json["content"],
        image: json["image"],
        url: json["url"],
        sequenceOrder: json["sequence_order"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
        "title": title,
        "subtitle": subtitle,
        "content": content,
        "image": image,
        "url": url,
        "sequence_order": sequenceOrder,
        "is_active": isActive,
      };
}
