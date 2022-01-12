import 'package:flutter/material.dart';

class CustomChip extends StatefulWidget {
  Color? backgroundColorActive;
  String title;
  Function(bool active)? onTap;
  bool? active;
  bool? withGesture;
  CustomChip({
    Key? key,
    this.backgroundColorActive,
    required this.title,
    this.onTap,
    this.active = false,
    this.withGesture = true,
  }) : super(key: key);

  @override
  _CustomChipState createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  @override
  Widget build(BuildContext context) {
    return widget.withGesture == true
        ? GestureDetector(
            onTap: () {
              setState(() {
                widget.active = !widget.active!;
              });

              if (widget.onTap != null) widget.onTap!(widget.active ?? false);
            },
            child: MyChip(
                backgroundColorActive: widget.active == true
                    ? widget.backgroundColorActive ??
                        Theme.of(context).primaryColor
                    : null,
                title: widget.title))
        : MyChip(
            backgroundColorActive: widget.active == true
                ? widget.backgroundColorActive ?? Theme.of(context).primaryColor
                : null,
            title: widget.title);
  }
}

class MyChip extends StatelessWidget {
  Color? backgroundColorActive;
  String title;

  MyChip({
    Key? key,
    this.backgroundColorActive,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: backgroundColorActive,
      padding: const EdgeInsets.all(10.0),
      label: Text(title),
    );
  }
}
