import 'dart:convert';

class Workflow {
  Workflow({
    this.id = '',
    this.created,
    this.updated,
    this.title = '',
    this.url = '',
  });

  String? id;
  DateTime? created;
  DateTime? updated;
  String? title;
  String? url;

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
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "created": created?.millisecondsSinceEpoch,
        "updated": updated?.millisecondsSinceEpoch,
        "title": title,
        "url": url,
      };
}
