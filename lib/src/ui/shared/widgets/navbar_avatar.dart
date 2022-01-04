import 'package:flutter/material.dart';

class NavbarAvatar extends StatelessWidget {
  const NavbarAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: Image.asset('images/img_avatar.png', width: 30, height: 30),
      ),
    );
  }
}
