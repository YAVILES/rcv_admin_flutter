import 'dart:convert';

import 'package:rcv_admin_flutter/src/models/workflow_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class WorkFlowService {
  static String url = '/security/workflow';
  static Future<List<Workflow>> getWorkFlows() async {
    List<Workflow> workflows = [];
    try {
      final response = await API.list('$url/', params: {'not_paginator': true});
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        workflows = data.map((w) => Workflow.fromMap(w)).toList();
      }
      return workflows;
    } on ErrorAPI {
      rethrow;
    }
  }
}
