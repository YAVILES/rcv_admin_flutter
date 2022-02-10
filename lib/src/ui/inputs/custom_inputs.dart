import 'package:flutter/material.dart';

class CustomInputs {
  static InputDecoration buildInputDecoration({
    required String labelText,
    String? hintText,
    IconData? icon,
    BoxConstraints? constraints,
  }) {
    return InputDecoration(
      constraints: constraints,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon) : null,
    );
  }
}
