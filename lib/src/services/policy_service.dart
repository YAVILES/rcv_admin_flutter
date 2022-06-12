import 'dart:typed_data';

import 'package:dio/dio.dart';
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
      final response = await API.list(
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
}
