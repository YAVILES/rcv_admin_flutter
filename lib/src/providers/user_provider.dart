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
  bool loading = false;

  late GlobalKey<FormState> formUserKey;

  String? searchValue;

  bool validateForm() {
    return formUserKey.currentState!.validate();
  }

  Future getUsers({bool? isAdviser = false}) async {
    loading = true;
    notifyListeners();
    try {
      final response =
          await API.list('$url/', params: {'is_adviser': isAdviser});
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        users = responseData.results;
      }
      loading = false;
      notifyListeners();
      return users;
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
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

  Future<bool?> newUser(User user, PlatformFile? photo,
      {bool isAdviser = false}) async {
    if (validateForm()) {
      final mapData = {
        'is_staff': true,
        'is_adviser': isAdviser,
        if (photo?.bytes != null)
          'photo': MultipartFile.fromBytes(
            photo!.bytes!,
            filename: photo.name,
          ),
        ...user.toMapSave(excludePhoto: true),
      };

      final formData = FormData.fromMap(mapData);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          getUsers(isAdviser: isAdviser);
          user = User.fromMap(response.data);
          return true;
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<bool?> editUser(String id, User user, PlatformFile? photo,
      {bool isAdviser = false}) async {
    if (validateForm()) {
      final mapData = {
        'is_staff': true,
        'is_adviser': isAdviser,
        if (photo?.bytes != null)
          'photo': MultipartFile.fromBytes(
            photo!.bytes!,
            filename: photo.name,
          ),
        ...user.toMapSave(excludePhoto: true),
      };
      final formData = FormData.fromMap(mapData);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          getUsers(isAdviser: isAdviser);
          user = User.fromMap(response.data);
/*           users = users.map((_user) {
            if (_user['id'] == user.id) {
              _user = user.toMapSave();
            }
            return _user;
          }).toList(); */
          notifyListeners();
          return true;
        }
      } on ErrorAPI {
        rethrow;
      }
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

  search(value, {bool? isAdviser = false}) async {
    searchValue = value;
    loading = true;
    notifyListeners();
    try {
      final response = await API
          .list('$url/', params: {"search": value, "is_adviser": isAdviser});
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        users = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }
}
