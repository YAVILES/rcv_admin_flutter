import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/bank_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BankProvider with ChangeNotifier {
  String url = '/payment/bank';
  List<Map<String, dynamic>> banks = [];
  Bank? bank;
  bool loading = false;

  late GlobalKey<FormState> formBankKey;

  String? searchValue;

  bool validateForm() {
    return formBankKey.currentState!.validate();
  }

  Future<List<Map<String, dynamic>>> getBanks() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/', params: {"not_paginator": true});
      if (response.statusCode == 200) {
        banks = response.data!;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
    return banks;
  }

  Future<Bank?> getBank(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return Bank.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newBank(Bank bankRCV) async {
    if (validateForm()) {
      final mapDAta = bankRCV.toMap();
      final formData = FormData.fromMap(mapDAta);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          bank = Bank.fromMap(response.data);
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }

  Future<bool?> editBank(String id, Bank bankRCV) async {
    if (validateForm()) {
      final mapDAta = bankRCV.toMap();
      final formData = FormData.fromMap(mapDAta);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          bank = Bank.fromMap(response.data);
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }

  Future deleteBank(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        banks.removeWhere((bank) => bank['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteBanks(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        banks.removeWhere((bank) => ids.contains(bank['id'].toString()));
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
        banks = response.data!;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }
}
