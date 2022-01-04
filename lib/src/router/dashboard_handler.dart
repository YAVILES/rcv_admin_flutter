import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/nav_drawer_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/ui/views/banners_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/home_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/login_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/users_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/user_view.dart';
import 'package:rcv_admin_flutter/src/utils/preferences.dart';

class DashBoardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, params) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context!);

    if (authProvider.loggedInStatus == Status.loggedIn ||
        Preferences.getToken() != null) {
      return const HomeView();
    } else {
      return const LoginView();
    }
  });

  static Handler banner = Handler(handlerFunc: (context, params) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context!, listen: false);
    Provider.of<NavDrawerProvider>(context, listen: false)
        .setRouteCurrent(bannersRoute);
    if (authProvider.loggedInStatus == Status.loggedIn ||
        Preferences.getToken() != null) {
      return const BannersView();
    } else {
      return const LoginView();
    }
  });

  static Handler users = Handler(handlerFunc: (context, params) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context!, listen: false);
    Provider.of<NavDrawerProvider>(context, listen: false)
        .setRouteCurrent(bannersRoute);
    if (authProvider.loggedInStatus == Status.loggedIn ||
        Preferences.getToken() != null) {
      return const UsersView();
    } else {
      return const LoginView();
    }
  });

  static Handler user = Handler(handlerFunc: (context, params) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context!, listen: false);
    Provider.of<NavDrawerProvider>(context, listen: false)
        .setRouteCurrent(bannersRoute);
    if (authProvider.loggedInStatus == Status.loggedIn ||
        Preferences.getToken() != null) {
      if (params['uid']?.first != null) {
        return UserView(uid: params['uid']!.first);
      } else {
        return const UsersView();
      }
    } else {
      return const LoginView();
    }
  });
}
