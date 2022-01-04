import 'package:flutter/material.dart';

class NavDrawerProvider with ChangeNotifier {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _routeCurrent = '/';

  get navDrawer => null;

  setRouteCurrent(routeName) async {
    _routeCurrent = routeName;
    await Future.delayed(const Duration(milliseconds: 200));
    notifyListeners();
  }

  String get routeCurrent {
    return _routeCurrent;
  }
}
