import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rcv_admin_flutter/src/models/bank_model.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/payment_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/services/bank_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/payment_service.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PaymentProvider with ChangeNotifier {
  List<Map<String, dynamic>> payments = [];
  List<Option> methods = [];
  Option? _method;
  Option? coin;
  Policy? policy;
  PlatformFile? archive;
  String? archiveImage;
  Option? get method => _method;
  List<Map<String, dynamic>> _selecteds = [];

  List<Map<String, dynamic>> get selecteds => _selecteds;

  set selecteds(List<Map<String, dynamic>> selecteds) {
    _selecteds = selecteds;
    notifyListeners();
  }

  set method(Option? method) {
    _method = method;
    notifyListeners();
  }

  List<Option> availableMethods = [];
  Payment? payment;
  List<Bank> banks = [];
  Bank? bank;
  bool loading = false;
  bool loadingBanks = false;
  String reference = "";
  double amount = 0.00;
  late GlobalKey<FormState> formPaymentKey;

  String? searchValue;

  bool validateForm() {
    return formPaymentKey.currentState!.validate();
  }

  Future getPayments() async {
    loading = true;
    notifyListeners();
    try {
      payments = await PaymentService.getPaymentsMap({});
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  Future getBanksForCoin(Option c) async {
    coin = c;
    loadingBanks = true;
    notifyListeners();
    try {
      List<Map<String, dynamic>> data = await BankService.getBanks({
        "not_paginator": true,
        "coin": c.value,
        "status": 1,
      });
      banks = data.map((e) => Bank.fromMap(e)).toList();
      loadingBanks = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loadingBanks = false;
      notifyListeners();
    }
  }

  Future getMethods() async {
    methods = await PaymentService.getMethods() ?? [];
  }

  setAvailableMethods() {
    if (bank != null) {
      availableMethods = bank!.methods!
          .map((e) =>
              methods.firstWhere((element) => element.value == e.toString()))
          .toList();
    } else {
      availableMethods = [];
    }
    notifyListeners();
  }

  Future<Payment?> getPayment(String uid) async {
    try {
      final response = await PaymentService.getPayment(uid);
      if (response != null) {
        return response;
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> savePayment() async {
    if (validateForm() && archive != null) {
      final mapData = {
        "bank": bank?.id,
        "policy": policy?.id,
        "reference": reference,
        "amount": amount,
        "method": method?.value,
        "coin": coin?.value,
        'archive': MultipartFile.fromBytes(
          archive!.bytes!,
          filename: archive!.name,
        ),
      };
      final formData = FormData.fromMap(mapData);
      final response = await PaymentService.newPayment(formData);
      if (response != null) {
        payment = response;
        return true;
      }
      return false;
    }
    return null;
  }

  Future rejectedPayments(List<String> ids) async {
    loading = true;
    notifyListeners();
    try {
      final rejected = await PaymentService.rejectedPayments(ids);
      if (rejected) {
        payments = await PaymentService.getPaymentsMap({});
        notifyListeners();
      }
      loading = false;
      notifyListeners();
      return rejected;
    } on ErrorAPI {
      rethrow;
    }
  }

  Future approvePayments(List<String> ids) async {
    loading = true;
    notifyListeners();
    try {
      final rejected = await PaymentService.approvePayments(ids);
      if (rejected) {
        payments = await PaymentService.getPaymentsMap({});
      }
      loading = false;
      notifyListeners();
      return rejected;
    } on ErrorAPI {
      rethrow;
    }
  }

  Future rejectedPayment() async {
    try {
      final rejected =
          await PaymentService.rejectedPayment(payment!.id.toString());
      if (rejected) {
        payment!.status = PaymentService.rejected;
        notifyListeners();
      }
      return rejected;
    } on ErrorAPI {
      rethrow;
    }
  }

  Future approvePayment() async {
    try {
      final rejected =
          await PaymentService.approvePayment(payment!.id.toString());
      if (rejected) {
        payment!.status = PaymentService.accepted;
        notifyListeners();
      }
      return rejected;
    } on ErrorAPI {
      rethrow;
    }
  }

  search(value) async {
    searchValue = value;
    loading = true;
    notifyListeners();
    try {
      payments = await PaymentService.getPaymentsMap({"search": value});
      loading = false;
      notifyListeners();
    } on ErrorAPI catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  downloadArchive() async {
    if (!kIsWeb) {
      if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
        bool status = await Permission.storage.isGranted;

        if (!status) await Permission.storage.request();
      }
    }
    Uint8List? data = await PaymentService.downloadArchive(payment!.id!);
    if (data != null) {
      MimeType type = MimeType.JPEG;
      String path = await FileSaver.instance.saveFile(
        "pago ${payment?.number.toString()}",
        data,
        "jpeg",
        mimeType: type,
      );
      NotificationService.showSnackbarSuccess('Documento guardado en $path');
    } else {
      NotificationService.showSnackbarError(
          'No se pudo descargar el documento');
    }
  }
}
