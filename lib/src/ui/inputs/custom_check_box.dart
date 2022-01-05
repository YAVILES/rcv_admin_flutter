import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  bool value;
  Function onChanged;
  String? title;
  CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.title,
  }) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title ?? 'Activo'),
      onChanged: (bool? value) => setState(() {
        widget.value = value ?? false;
        widget.onChanged(value);
      }),
      value: widget.value,
      contentPadding: EdgeInsets.zero,
    );
  }
}
