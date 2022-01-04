import 'package:flutter/material.dart';

import 'package:rcv_admin_flutter/src/components/nav_drawer/drawer_item.dart';

class DrawerItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final String navigationPath;
  final List<NavBarItem> children;

  const DrawerItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.navigationPath,
    required this.children,
  }) : super(key: key);

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(widget.icon),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.title),
          )
        ],
      ),
      children: widget.children,
    );
  }
}
