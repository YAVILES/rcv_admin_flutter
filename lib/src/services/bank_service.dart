import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BankService {
  static String url = '/payment/bank';

  static Future getBanks(Map<String, dynamic>? params) async {
    try {
      final response = await API.list('$url/', params: params);
      if (response.statusCode == 200) {
        if (params?["not_paginator"] != null) {
          return List<Map<String, dynamic>>.from(response.data);
        }
        return ResponseData.fromMap(response.data);
      }
    } on ErrorAPI {
      rethrow;
    }
    return [];
  }

  static Future<ResponseData?> getBanksPaginated(
      Map<String, dynamic>? params, String? _url) async {
    try {
      final response = await API.list('${_url ?? url}/', params: params);
      if (response.statusCode == 200) {
        return ResponseData.fromMap(response.data);
      }
    } on ErrorAPI {
      rethrow;
    }
    return null;
  }

  static Future<Uint8List?> export() async {
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

  static Future<Uint8List?> downloadImage(String id) async {
    try {
      final response = await API.list(
        '$url/$id/download_image/',
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

  static Future import(PlatformFile archive) async {
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
}
