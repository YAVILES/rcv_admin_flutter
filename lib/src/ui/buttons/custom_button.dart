import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function onPressed;

  CustomButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Custom Button"),
        ],
      ),
    );
  }
}
