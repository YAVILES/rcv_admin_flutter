import 'package:dio/dio.dart';
import 'package:rcv_admin_flutter/src/models/client_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ClientService {
  static String url = '/security/client';

  static Future<List<Client>> getClients(Map<String, dynamic>? params) async {
    List<Client> clients = [];
    try {
      final response = await API.get('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        clients = data.map((w) => Client.fromMap(w)).toList();
      }
      return clients;
    } on ErrorAPI {
      rethrow;
    }
  }

  static Future<Client?> getClient(String uid) async {
    try {
      Response response;
      response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Client.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  static Future<List<String>> getClientsOnlyName(
      Map<String, dynamic>? params) async {
    List<String> clients = [];
    try {
      final response = await API.get('$url/', params: params);
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        clients = data.map((w) => Client.fromMap(w).fullName!).toList();
      }
      return clients;
    } on ErrorAPI {
      rethrow;
    }
  }
}
