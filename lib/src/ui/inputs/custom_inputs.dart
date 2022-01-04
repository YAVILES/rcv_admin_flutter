import 'package:flutter/material.dart';

class CustomInputs {
  static InputDecoration buildInputDecoration({
    required String hintText,
    required String labelText,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(
        icon,
      ),
    );
  }
}
