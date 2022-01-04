import 'package:flutter/material.dart';

class LoginFormProvider with ChangeNotifier {
  final GlobalKey<FormState> formLoginKey = GlobalKey<FormState>();
  bool loading = false;
  String password = "";
  String username = "";
  String errorMessage = "";

  bool validateForm() {
    return formLoginKey.currentState!.validate();
  }

  saveForm() {
    {
      if (loading) {
        loading = true;
        errorMessage = "";
      }
      if (validateForm()) {
        formLoginKey.currentState!.save();
      } else {
        loading = false;
        errorMessage = "";
      }
    }
  }
}
