import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:rcv_admin_flutter/src/utils/preferences.dart';

class API {
  // Development
  static const String baseURL = "http://127.0.0.1:8000/api";

  // Production
  // static const String baseURL = "http://194.163.161.64:6500/api";
  static final Dio _dio = Dio();

  static void configureDio() {
    _dio.options.baseUrl = baseURL;
    _dio.options.headers = {
      'Authorization': 'Bearer ${Preferences.getToken()}',
      'accept': '*/*',
    };
    initializedInterceptors();
  }

  static initializedInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, errorHandler) {
          print('onErrorMessage: ${error.response}');
          return errorHandler.next(error);
        },
        onRequest: (RequestOptions request, requestHandler) {
          print("onRequest : ${request.method} ${request.uri}");
          return requestHandler.next(request);
        },
        onResponse: (response, responseHandler) {
          print('${response.statusCode}');
          return responseHandler.next(response);
        },
      ),
    );
  }

  static Future<Response> get(String path) async {
    Response response;
    try {
      response = await _dio.get(path);
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }
    return response;
  }

  static Future<Response> list(String path) async {
    Response response;
    try {
      response = await _dio.get(path);
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }
    return response;
  }

  static Future<Response> add(String path, data) async {
    Response response;
    try {
      response = await _dio.post(path, data: data);
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }

    return response;
  }

  static Future<Response> put(String path, data) async {
    Response response;
    try {
      response = await _dio.put(path, data: data);
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }
    return response;
  }

  static Future<Response> patch(String path, data) async {
    Response response;
    try {
      response = await _dio.patch(path, data: data);
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }
    return response;
  }

  static Future<Response> delete(String path) async {
    Response response;
    try {
      response = await _dio.delete(path);
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }
    return response;
  }

  static Future<Response> uploadFile(String path, Uint8List bytes) async {
    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(bytes),
    });
    Response response;
    try {
      response = await _dio.patch(path, data: formData);
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }
    return response;
  }
}

class ErrorAPI {
  dynamic detail;

  ErrorAPI({
    this.detail,
  });

  Map<String, dynamic> toMap() {
    return {
      'detail': detail,
    };
  }

  factory ErrorAPI.fromMap(Map<String, dynamic> map) {
    return ErrorAPI(
      detail: map['detail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorAPI.fromJson(String source) =>
      ErrorAPI.fromMap(json.decode(source));
}
