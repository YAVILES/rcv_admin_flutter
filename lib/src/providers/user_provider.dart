import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UserProvider with ChangeNotifier {
  String url = '/security/user';
  List<Map<String, dynamic>> users = [];

  Future getUsers() async {
    final response = await API.list('$url/');
    ResponseData responseData = ResponseData.fromMap(response);
    users = responseData.results;
    notifyListeners();
  }

  Future<User?> getUser(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      return User.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  Future newUser(title, subtitle) async {
    final data = {
      'title': title,
      'subtitle': subtitle,
      'content': 'asdas',
      'url': 'aisasm'
    };
    try {
      final response = await API.add('$url/', data);
      users.add(response);
      notifyListeners();
    } catch (e) {
      throw 'Error al crear el usuario';
    }
  }

  Future editUser(String id, Map<String, dynamic> data) async {
    try {
      await API.put('$url/$id/', data);
      users = users.map((user) {
        if (user['id'] != id) return user;
        user['name'] = data['name'];
        user['username'] = data['username'];
        user['email'] = data['email'];
        user['direction'] = data['direction'];
        return user;
      }).toList();
      notifyListeners();
    } catch (e) {
      throw 'Error al editar el usuario';
    }
  }

  Future deleteUser(String id) async {
    try {
      await API.delete('$url/$id/');
      users.removeWhere((user) => user['id'] == id);
      notifyListeners();
    } catch (e) {
      throw 'No se pudo borrar el usuario';
    }
  }

  void sort<T>(Comparable<T> Function(Map<String, dynamic> user) getField) {
    users.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);

      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }
}
