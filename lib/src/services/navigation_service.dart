import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static navigateTo(
      BuildContext context, String routeName, Map<String, String>? params) {
    return context.goNamed(routeName, params: params ?? {});
    // return navigatorKey.currentState!.pushNamed(routeName);
  }

  static backTo(BuildContext context) {
    return GoRouter.of(context).pop(context);
  }
}
