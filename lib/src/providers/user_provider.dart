import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User();

  User get user => _user;

  setUser(User user) {
    _user = user;
    notifyListeners();
    return user;
  }
}
