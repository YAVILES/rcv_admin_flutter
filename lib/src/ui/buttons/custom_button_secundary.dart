import 'package:flutter/material.dart';

class CustomButtonSecundary extends StatelessWidget {
  Function onPressed;
  String title;

  CustomButtonSecundary({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(title),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
      ),
    );
  }
}
