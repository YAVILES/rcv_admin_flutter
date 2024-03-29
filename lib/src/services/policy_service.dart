import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PolicyService {
  static String url = '/core/policy';

  // Estatus
  static int get outstanding => 0;
  static int get pendingApproval => 1;
  static int get passed => 2;
  static int get expired => 3;
  static int get rejected => 4;

  static Future<Uint8List?> downloadPdf(String id) async {
    try {
      final response = await API.get(
        '$url/$id/download_pdf/',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  static Future<Uint8List?> pdf(String id) async {
    try {
      final response = await API.get(
        '$url/$id/pdf/',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  static Future<List<Policy>?> getPolicies(String vehicleId) async {
    try {
      final response =
          await API.get('$url/?vehicle=$vehicleId&not_paginator=true');
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        return data.map((w) => Policy.fromMap(w)).toList();
      }
      return null;
    } on ErrorAPI {
      rethrow;
    }
  }
}
