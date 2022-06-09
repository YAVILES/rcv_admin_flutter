import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonPrimary extends StatelessWidget {
  Function onPressed;
  String? title;
  String? tooltipMessage;
  Color? color;

  CustomButtonPrimary({
    Key? key,
    required this.onPressed,
    this.title,
    this.color,
    this.tooltipMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tooltipMessage != null
        ? Tooltip(
            message: tooltipMessage,
            child: MyButtomPrimary(
                color: color, onPressed: onPressed, title: title),
          )
        : MyButtomPrimary(color: color, onPressed: onPressed, title: title);
  }
}

class MyButtomPrimary extends StatelessWidget {
  const MyButtomPrimary({
    Key? key,
    required this.color,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final Color? color;
  final Function onPressed;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              color != null ? MaterialStateProperty.all(color) : null,
        ),
        onPressed: () => onPressed(),
        child: Text(title ?? "Custom Button Primary"),
      ),
    );
  }
}
