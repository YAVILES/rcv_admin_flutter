import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/auth/auth_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/splash/splash_layout.dart';
import 'package:rcv_admin_flutter/src/ui/views/banners_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/home_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/login_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/not_found_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/users_view.dart';

// Código Go RouterGoRouter

class RouterGoRouter {
  static GoRouter generateRoute(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return GoRouter(
        debugLogDiagnostics: true,
        routes: [
          GoRoute(
            name: rootRoute,
            path: '/',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const HomeView(),
            ),
          ),
          GoRoute(
            name: loginRoute,
            path: '/$loginRoute',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const LoginView(),
            ),
          ),
          GoRoute(
            name: dashBoardRoute,
            path: '/$dashBoardRoute',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const HomeView(),
            ),
          ),
          GoRoute(
            name: bannersRoute,
            path: '/$bannersRoute',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const BannersView(),
            ),
          ),
          GoRoute(
            name: usersRoute,
            path: '/$usersRoute',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const UsersView(),
            ),
          ),
        ],
        // initialLocation: rootRoute,
        navigatorBuilder: (context, child) {
          if (auth.loggedInStatus == Status.loggedIn) {
            return DashBoardLayout(child: child!);
          }

          if (auth.loggedInStatus == Status.authenticating) {
            return const SplashLayout();
          }

          return AuthLayout(child: child!);
        },
        redirect: (state) {
          final loggingIn = state.subloc == '/$loginRoute';

          if (auth.loggedInStatus != Status.loggedIn &&
              auth.loggedInStatus != Status.authenticating) {
            return loggingIn ? null : '/$loginRoute';
          }
          // if the user is logged in but still on the login page, send them to
          // the home page
          if (loggingIn) return '/$dashBoardRoute';

          // no need to redirect at all
          return null;
        },
        refreshListenable: auth,
        errorBuilder: (context, state) {
          return Center(
            child: NotFoundView(
              error: state.error.toString(),
            ),
          );
        });
  }
}
