import 'package:flutter/material.dart';

import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_secundary.dart';

class HeaderView extends StatelessWidget {
  HeaderView({
    Key? key,
    this.title,
    this.subtitle,
    this.actions,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  List<dynamic>? actions;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 25, left: 25, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      subtitle ?? '',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            children: [...?actions],
          ),
        ],
      ),
    );
  }
}
