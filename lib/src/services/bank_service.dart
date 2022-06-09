import 'package:rcv_admin_flutter/src/models/bank_model.dart';
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
}
