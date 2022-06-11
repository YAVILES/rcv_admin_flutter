import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UtilsService {
  static Future<ResponseData?> getListPaginated(
      Map<String, dynamic>? params, String url) async {
    try {
      final response = await API.list(url, params: params);
      if (response.statusCode == 200) {
        return ResponseData.fromMap(response.data);
      }
    } on ErrorAPI {
      rethrow;
    }
    return null;
  }

  static Future import(url, PlatformFile archive) async {
    var file = MultipartFile.fromBytes(
      archive.bytes!,
      filename: archive.name,
    );
    FormData formData = FormData.fromMap({"file": file});
    try {
      final response = await API.add('$url/_import/', formData);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  static Future<Uint8List?> export(url) async {
    try {
      final response = await API.list(
        '$url/export/',
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
