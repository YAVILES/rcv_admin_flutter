import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonPrimary extends StatelessWidget {
  Function onPressed;
  String? title;
  Color? color;

  CustomButtonPrimary({
    Key? key,
    required this.onPressed,
    this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            color != null ? MaterialStateProperty.all(color) : null,
      ),
      onPressed: () => onPressed(),
      child: Text(title ?? "Custom Button Primary"),
    );
  }
}
