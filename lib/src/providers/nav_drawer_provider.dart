import 'package:flutter/material.dart';

class NavDrawerProvider with ChangeNotifier {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _routeCurrent = '/';

  static bool _activeBackButton = true;

  String get routeCurrent => _routeCurrent;

  static bool get activeBackButton => _activeBackButton;

  setRouteCurrent(routeName) async {
    _routeCurrent = routeName;
    await Future.delayed(const Duration(milliseconds: 200));
    notifyListeners();
  }

  setActiveBackButton(bool value) async {
    _activeBackButton = value;
    await Future.delayed(const Duration(milliseconds: 200));
    notifyListeners();
  }
}
