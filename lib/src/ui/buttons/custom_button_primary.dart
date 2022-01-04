import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonPrimary extends StatelessWidget {
  Function onPressed;
  String? title;

  CustomButtonPrimary({
    Key? key,
    required this.onPressed,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(title ?? "Custom Button Primary"),
    );
  }
}
