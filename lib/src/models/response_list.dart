// To parse this JSON data, do
//
//     final responseData = responseDataFromMap(jsonString);

import 'dart:convert';

class ResponseData {
  ResponseData({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Map<String, dynamic>> results;

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results,
    };
  }

  factory ResponseData.fromMap(Map<String, dynamic> map) {
    return ResponseData(
      count: map['count']?.toInt() ?? 0,
      next: map['next'],
      previous: map['previous'],
      results: List<Map<String, dynamic>>.from(map['results']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseData.fromJson(String source) =>
      ResponseData.fromMap(json.decode(source));
}
