import 'dart:async';
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
      user = User.fromMap(resp);
      _loggedInStatus = Status.loggedIn;
      notifyListeners();
      return true;
    } catch (e) {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> login(
      BuildContext context, String username, String password) async {
    Map<String, Object> result;

    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };

    /* _loggedInStatus = Status.Authenticating;
    notifyListeners(); */
    API.add('/token/', loginData).then((value) {
      var data = Auth.fromMap(value);
      user = data.user;
      Preferences.setToken(data.token, data.refresh);
      _loggedInStatus = Status.loggedIn;
      API.configureDio();
      notifyListeners();
    }).catchError(
      (e) {
        print(e);
        _loggedInStatus = Status.notLoggedIn;
        notifyListeners();
        NotificationService.showSnackbarError('Usuario/ contraseña no válido');
      },
    );

/*  final Map<String, dynamic> responseData = json.decode(response.toString());
    // var userData = responseData['user'];
*/
    //

    // _loggedInStatus = Status.LoggedIn;
    notifyListeners();

    // result = {'status': true, 'message': 'Successful', 'user': authUser};
    result = {'status': true, 'message': 'Successful', 'user': {}};
    /* } else {
      result = {'status': false, 'message': ""};
      if (responseData['username'] && responseData['password']) {
        result['message'] = "Las credenciales ingresadas son incorrectas";
      } else if (responseData['username']) {
        result['message'] = "El usuario es requerido";
      } else if (responseData['password']) {
        result['message'] = "El password es requerido";
      } else if (responseData['detail']) {}

      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    }  */
    return result;
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
