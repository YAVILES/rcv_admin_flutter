import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({Key? key, this.title, this.subtitle}) : super(key: key);

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title ?? ''),
            Text(subtitle ?? ''),
          ],
        ),
      ],
    );
  }
}
