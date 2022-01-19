import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';

class TotalCoverageProvider with ChangeNotifier {
  List<Premium> _premiums = [];

  List<Premium> get premiums => _premiums;

  set premiums(List<Premium> premiums) {
    _premiums = premiums;
    notifyListeners();
  }
}
