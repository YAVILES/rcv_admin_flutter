import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class NavBarItem extends StatefulWidget {
  final String title;
  final String navigationPath;
  final IconData icon;
  final Function onPressed;
  bool isActive = false;

  NavBarItem({
    Key? key,
    required this.title,
    required this.navigationPath,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  }) : super(key: key);

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: ListTile(
        selected: widget.isActive,
        selectedColor: Theme.of(context).primaryColor,
        dense: false,
        visualDensity: VisualDensity.comfortable,
        title: Text(widget.title),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Icon(widget.icon),
        ),
        onTap: () {
          if (widget.isActive) null;
          widget.onPressed();
          /*  Navigator.pushNamed(context, navigationPath); */
        },
      ),
    );
  }
}
