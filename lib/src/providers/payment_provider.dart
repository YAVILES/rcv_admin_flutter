import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/payment_model.dart';
import 'package:rcv_admin_flutter/src/services/payment_service.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PaymentProvider with ChangeNotifier {
  List<Map<String, dynamic>> payments = [];
  Payment? payment;
  bool loading = false;

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

  Future<bool?> newPayment(Payment payment) async {
    if (validateForm()) {
      final response = await PaymentService.newPayment(payment);
      if (response != null) {
        payment = response;
        getPayments();
        return true;
      }
      return false;
    }
    return null;
  }

  Future rejectedPayments(List<String> ids) async {
    try {
      final rejected = await PaymentService.rejectedPayments(ids);
      if (rejected) {
        payments = await PaymentService.getPaymentsMap({});
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
}
