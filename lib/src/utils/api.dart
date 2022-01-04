import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:rcv_admin_flutter/src/utils/preferences.dart';

class API {
  static const String api = "";

  static const String baseURL = "http://127.0.0.1:8000/api";
  static const String register = baseURL + "/security/user/";
  static const String forgotPassword = baseURL + "/security/forgot-password/";

  static const String banner = baseURL + "/core/banner/";
  static final Dio _dio = Dio();

  static void configureDio() {
    _dio.options.baseUrl = baseURL;
    _dio.options.headers = {
      'Authorization': 'Bearer ${Preferences.getToken()}',
      'accept': 'application/json'
    };
  }

  static Future get(String path) async {
    try {
      var response = await _dio.get(path);
      return response.data;
    } on DioError catch (e) {
      return e;
    }
  }

  static Future list(String path) async {
    try {
      var response = await _dio.get(path);
      return response.data;
    } on DioError catch (e) {
      return e;
    }
  }

  static Future add(String path, Map<String, dynamic> data) async {
    try {
      var response = await _dio.post(path, data: data);
      return response.data;
    } on DioError catch (e) {
      return e;
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    try {
      var response = await _dio.put(path, data: data);
      return response.data;
    } on DioError catch (e) {
      return e;
    }
  }

  static Future patch(String path, data) async {
    try {
      var response = await _dio.patch(path, data: data);
      return response.data;
    } on DioError catch (e) {
      return e;
    }
  }

  static Future delete(String path) async {
    try {
      var response = await _dio.delete(path);
      return response.data;
    } on DioError catch (e) {
      return e;
    }
  }

  static Future uploadFile(String path, Uint8List bytes) async {
    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(bytes),
    });
    try {
      var response = await _dio.patch(path, data: formData);
      return response.data;
    } on DioError catch (e) {
      return e;
    }
  }
}
