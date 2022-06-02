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
        onError: (error, errorHandler) async {
          print(
              'onErrorMessage: ${error.response} ${error.response?.statusCode} ${error.requestOptions.path}');
          if ((error.response?.statusCode == 403 ||
                  error.response?.statusCode == 401) &&
              error.requestOptions.path != '/token/' &&
              error.requestOptions.path != '/security/user/current/') {
            Response response = await refreshToken();
            if (response.statusCode == 200) {
              //get new tokens ...
              final data = response.data;
              Preferences.setToken(data['access'], data['refresh']);
              API.configureDio();
              //create request with new access token
              final opts = Options(method: error.requestOptions.method);
              final cloneReq = await _dio.request(error.requestOptions.path,
                  options: opts,
                  data: error.requestOptions.data,
                  queryParameters: error.requestOptions.queryParameters);

              return errorHandler.resolve(cloneReq);
            }
            return errorHandler.next(error);
          } else {
            return errorHandler.next(error);
          }
        },
        onRequest: (RequestOptions request, requestHandler) {
          print("onRequest: ${request.method} ${request.uri}");
          return requestHandler.next(request);
        },
        onResponse: (response, responseHandler) {
          print('onResponse: ${response.statusCode}');
          return responseHandler.next(response);
        },
      ),
    );
  }

  static Future<Response> refreshToken() async {
    Response response;
    final refreshToken = Preferences.getRefreshToken();
    try {
      response =
          await _dio.post('/token/refresh/', data: {'refresh': refreshToken});
    } on DioError catch (e) {
      throw ErrorAPI.fromJson(e.response.toString());
    }
    return response;
  }

  static Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return await _dio.post(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
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

  static Future<Response> list(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    Response response;
    try {
      response = await _dio.get(path, queryParameters: params);
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

  static Future<Response> delete(String path, {List<String>? ids}) async {
    Response response;
    try {
      if (ids == null) {
        response = await _dio.delete(path);
      } else {
        response = await _dio.delete(path, data: {'ids': ids});
      }
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
  List<String>? error;

  ErrorAPI({
    this.detail,
    this.error,
  });

  Map<String, dynamic> toMap() {
    return {
      'detail': detail,
      'error': error,
    };
  }

  factory ErrorAPI.fromMap(Map<String, dynamic> map) {
    return ErrorAPI(
      detail: map['detail'],
      error: map['error'] != null ? List<String>.from(map['error']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorAPI.fromJson(String source) =>
      ErrorAPI.fromMap(json.decode(source));
}
