import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UserFormProvider with ChangeNotifier {
  User? user;
  late GlobalKey<FormState> formKey;

  Future uploadImage(String id, Uint8List bytes) async {
    try {
      final resp = await API.uploadFile('/security/user/$id/', bytes);
      if (resp.statusCode == 200) {
        user = User.fromMap(resp.data);
        notifyListeners();
        return user;
      } else {
        return null;
      }
    } on ErrorAPI catch (e) {
      throw 'Error al cargar file';
    }
  }
}
