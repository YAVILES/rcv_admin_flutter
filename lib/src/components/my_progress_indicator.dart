import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
