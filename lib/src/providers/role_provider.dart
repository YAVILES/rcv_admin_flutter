import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/role_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class RoleProvider with ChangeNotifier {
  String url = '/security/role';
  List<Map<String, dynamic>> roles = [];
  Role? role;
  bool loading = false;

  late GlobalKey<FormState> formRoleKey;

  String? searchValue;

  bool validateForm() {
    return formRoleKey.currentState!.validate();
  }

  Future getRoles() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        roles = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
      print(e);
    }
  }

  Future<Role?> getRole(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Role.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future newRole(Role roleRCV) async {
    if (validateForm()) {
      final mapDAta = roleRCV.toMap();
      final formData = FormData.fromMap(mapDAta);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          role = Role.fromMap(response.data);
          getRoles();
          // roles.add(response.data);
          // notifyListeners();
        }
        return response;
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future editRole(int id, Role roleRCV) async {
    if (validateForm()) {
      final mapDAta = roleRCV.toMap();
      final formData = FormData.fromMap(mapDAta);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          role = Role.fromMap(response.data);
          getRoles();
/*           roles = roles.map((_role) {
            if (_role['id'] == role!.id) {
              _role = role!.toMap();
            }
            return _role;
          }).toList(); */
          // notifyListeners();
        }
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deleteRole(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        roles.removeWhere((role) => role['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteRoles(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        roles.removeWhere((role) => ids.contains(role['id'].toString()));
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
        roles = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }
}
