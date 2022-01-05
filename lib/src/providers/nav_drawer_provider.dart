import 'package:flutter/material.dart';

class NavDrawerProvider with ChangeNotifier {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _routeCurrent = '/';

  String get routeCurrent => _routeCurrent;

  setRouteCurrent(routeName) async {
    _routeCurrent = routeName;
    await Future.delayed(const Duration(milliseconds: 200));
    notifyListeners();
  }
}
