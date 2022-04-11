import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/auth_model.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';
import 'package:rcv_admin_flutter/src/utils/preferences.dart';

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.authenticating;
  final Status _registeredInStatus = Status.notRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  User? user;

  getUser() => user;

  AuthProvider() {
    isAuthenticated();
  }

  Future<bool> isAuthenticated() async {
    final token = Preferences.getToken();
    if (token == null) {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      return false;
    }
    try {
      final resp = await API.list('/security/user/current/');
      if (resp.statusCode == 200) {
        user = User.fromMap(resp.data);
        _loggedInStatus = Status.loggedIn;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      return false;
    }
  }

  Future<void> login(
      BuildContext context, String username, String password) async {
    final Map<String, String> loginData = {
      'username': username,
      'password': password
    };

    _loggedInStatus = Status.authenticating;
    notifyListeners();

    try {
      Response resp = await API.add('/token/', loginData);
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        var data = Auth.fromMap(resp.data);
        if (data.user != null) user = data.user;
        Preferences.setToken(data.token, data.refresh);
        Preferences.setIdUser(data.user?.id ?? '');
        API.configureDio();
        _loggedInStatus = Status.loggedIn;
        notifyListeners();
      } else {
        _loggedInStatus = Status.notLoggedIn;
        notifyListeners();
        NotificationService.showSnackbarError('Usuario / contraseña no válido');
      }
    } on ErrorAPI catch (e) {
      if (e.detail == null) {
        NotificationService.showSnackbarError('Usuario / contraseña no válido');
      } else {
        NotificationService.showSnackbarError(
            (e.detail is String) ? e.detail : 'Usuario / contraseña no válido');
      }

      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    Preferences.removetoken();
    _loggedInStatus = Status.notLoggedIn;
    notifyListeners();
  }

/*   Future<FutureOr> register(
      String email, String password, String passwordConfirmation) async {
    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await post(Uri.parse(API.register),
            body: json.encode(registrationData),
            headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }
 */
/*   static Future<FutureOr> onValue(Response response) async {
    Map<String, Object> result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }
 */
}
