import 'package:dio/dio.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/payment_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PaymentService {
  static String url = '/payment/payment';

  // Métodos de pago
  static int get transfer => 0;
  static int get mobilePayment => 1;
  static int get cash => 2;
  static int get zelle => 3;
  static int get other => 4;

  // Estatus
  static int get pending => 0;
  static int get rejected => 1;
  static int get accepted => 2;

  static Future<List<Map<String, dynamic>>> getPaymentsMap(
      Map<String, dynamic>? params) async {
    List<Map<String, dynamic>> data = [];
    try {
      final response = await API
          .list('$url/', params: {...params ?? {}, "not_paginator": true});
      if (response.statusCode == 200) {
        List<Map<String, dynamic>>.from(response.data);
      }
      return data;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<ResponseData?> getPaymentsPaginated(
      Map<String, dynamic>? params, String? _url) async {
    try {
      final response = await API.list('${_url ?? url}/', params: params);
      if (response.statusCode == 200) {
        return ResponseData.fromMap(response.data);
      }
      return null;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<Payment?> getPayment(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Payment.fromJson(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  static Future rejectedPayments(List<String> ids) async {
    try {
      final resp = await API.add('$url/rejected_payments/', {"payments": ids});
      if (resp.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<Payment?> newPayment(FormData formData) async {
    try {
      final response = await API.add('$url/', formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Payment.fromJson(response.data);
      }
      return null;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<List<Option>?> getMethods() async {
    try {
      final response =
          await API.list('$url/field_options/', params: {"field": "method"});
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        return data.map((w) => Option.fromMap(w)).toList();
      } else {
        return [];
      }
    } on ErrorAPI {
      return null;
    }
  }

  static Future<List<Option>?> getCoins() async {
    try {
      final response = await API.list('/coin/');
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        return data.map((w) => Option.fromMap(w)).toList();
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }
}
