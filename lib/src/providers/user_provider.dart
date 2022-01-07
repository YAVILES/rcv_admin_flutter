import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UserProvider with ChangeNotifier {
  String url = '/security/user';
  List<Map<String, dynamic>> users = [];
  User? user;

  late GlobalKey<FormState> formUserKey;

  Future getUsers() async {
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        users = responseData.results;
        notifyListeners();
      }
    } on ErrorAPI catch (e) {
      print(e);
    }
  }

  Future<User?> getUser(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return User.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future newUser(User user, PlatformFile? photo) async {
    final mapData = {
      if (photo?.bytes != null)
        'photo': MultipartFile.fromBytes(
          photo!.bytes!,
          filename: photo.name,
        ),
      ...user.toMap(excludePhoto: true),
    };
    print(mapData);
    final formData = FormData.fromMap(mapData);
    try {
      final response = await API.add('$url/', formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        user = User.fromMap(response.data);
        users.add(response.data);
        notifyListeners();
      }
      return response;
    } on ErrorAPI {
      rethrow;
    }
  }

  Future editUser(String id, User user, PlatformFile? photo) async {
    final mapData = {
      if (photo?.bytes != null)
        'photo': MultipartFile.fromBytes(
          photo!.bytes!,
          filename: photo.name,
        ),
      ...user.toMap(excludePhoto: true),
    };
    final formData = FormData.fromMap(mapData);

    try {
      final response = await API.put('$url/$id/', formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        user = User.fromMap(response.data);
        users = users.map((_user) {
          if (_user['id'] == user.id) {
            _user = user.toMap();
          }
          return _user;
        }).toList();
        notifyListeners();
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteUser(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        users.removeWhere((user) => user['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }
}
