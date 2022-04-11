import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/client_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ClientProvider with ChangeNotifier {
  String url = '/security/client';
  List<Map<String, dynamic>> clients = [];
  Client? client;
  bool loading = false;

  late GlobalKey<FormState> formClientKey;

  String? searchValue;

  bool validateForm() {
    return formClientKey.currentState!.validate();
  }

  Future getClients() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        clients = responseData.results;
      }
      loading = false;
      notifyListeners();
      return clients;
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }

  Future<List<Client>> getAllClients(Map<String, dynamic>? params) async {
    List<Client> clients = [];
    try {
      final response = await API.list('$url/', params: params);
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

  Future<Client?> getClient(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Client.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newClient(Client client, PlatformFile? photo) async {
    if (validateForm()) {
      final mapData = {
        'is_staff': true,
        if (photo?.bytes != null)
          'photo': MultipartFile.fromBytes(
            photo!.bytes!,
            filename: photo.name,
          ),
        ...client.toMap(excludePhoto: true),
      };

      final formData = FormData.fromMap(mapData);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          getClients();
          client = Client.fromMap(response.data);
          return true;
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<bool?> editClient(
      String id, Client client, PlatformFile? photo) async {
    if (validateForm()) {
      final mapData = {
        'is_staff': true,
        if (photo?.bytes != null)
          'photo': MultipartFile.fromBytes(
            photo!.bytes!,
            filename: photo.name,
          ),
        ...client.toMap(excludePhoto: true),
      };
      final formData = FormData.fromMap(mapData);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          getClients();
          client = Client.fromMap(response.data);
/*           clients = clients.map((_client) {
            if (_client['id'] == client.id) {
              _client = client.toMap();
            }
            return _client;
          }).toList(); */
          notifyListeners();
          return true;
        }
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deleteClient(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        clients
            .removeWhere((client) => client['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  search(value) async {
    searchValue = value;
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/', params: {"search": value});
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        clients = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }
}
