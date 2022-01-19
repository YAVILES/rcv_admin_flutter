import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rcv_admin_flutter/src/providers/nav_drawer_provider.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static navigateTo(
      BuildContext context, String routeName, Map<String, String>? params) {
    return context.goNamed(routeName, params: params ?? {});
    // return navigatorKey.currentState!.pushNamed(routeName);
  }

  static back(BuildContext context) {
    GoRouter.of(context).pop(context);
  }
}
