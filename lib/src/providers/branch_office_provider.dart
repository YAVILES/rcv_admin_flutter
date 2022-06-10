import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/branch_office_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BranchOfficeProvider with ChangeNotifier {
  String url = '/core/branch_office';
  List<Map<String, dynamic>> branchOffices = [];
  BranchOffice? branchOffice;
  bool loading = false;
  late GlobalKey<FormState> formBranchOfficeKey;
  String? searchValue;

  bool validateForm() {
    return formBranchOfficeKey.currentState!.validate();
  }

  Future getBranchOffices() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        branchOffices = responseData.results;
      }
      loading = false;
      notifyListeners();
      return branchOffices;
    } on ErrorAPI {
      loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<BranchOffice?> getBranchOffice(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return BranchOffice.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newBranchOffice(BranchOffice branchOffice) async {
    if (validateForm()) {
      final mapData = branchOffice.toMap();
      try {
        final response = await API.add('$url/', mapData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          getBranchOffices();
          branchOffice = BranchOffice.fromMap(response.data);
          return true;
        }
      } catch (e) {
        rethrow;
      }
    }
    return null;
  }

  Future<bool?> editBranchOffice(String id, BranchOffice branchOffice) async {
    if (validateForm()) {
      final mapData = branchOffice.toMap();

      try {
        final response = await API.put('$url/$id/', mapData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          branchOffice = BranchOffice.fromMap(response.data);
          getBranchOffices();
/*           BranchOffices = BranchOffices.map((_BranchOffice) {
            if (_BranchOffice['id'] == BranchOffice.id) {
              _BranchOffice = BranchOffice.toMap();
            }
            return _BranchOffice;
          }).toList(); */
          // notifyListeners();
          return true;
        }
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future deleteBranchOffice(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        branchOffices.removeWhere(
            (branchOffice) => branchOffice['id'].toString() == id.toString());
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
        branchOffices = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }
}
