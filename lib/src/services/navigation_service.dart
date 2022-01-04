import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static navigateTo(BuildContext context, String routeName) {
    return context.goNamed(routeName);
    // return navigatorKey.currentState!.pushNamed(routeName);
  }

  static replaceTo(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  static backTo(BuildContext context) {
    return GoRouter.of(context).pop(context);
  }
}
