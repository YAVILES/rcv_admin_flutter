import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';

import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/auth/auth_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/splash/splash_layout.dart';
import 'package:rcv_admin_flutter/src/ui/views/banner_view.dart';
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
        // debugLogDiagnostics: true,
        // initialLocation: '/banners/banner',
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
            routes: [
              GoRoute(
                name: bannerRoute,
                path: 'banner',
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    child: BannerView(),
                  );
                },
              ),
              GoRoute(
                name: bannerDetailRoute,
                path: 'banner/:id',
                pageBuilder: (context, state) {
                  BannerRCV banner = _getBannerRCV(
                    context,
                    state.params['id'].toString(),
                  );
                  return MaterialPage(
                    key: state.pageKey,
                    child: BannerView(banner: banner),
                  );
                },
              ),
            ],
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
        navigatorBuilder: (context, child) {
          if (auth.loggedInStatus == Status.loggedIn) {
            return Builder(builder: (context) {
              return DashBoardLayout(child: child!);
            });
          }

          if (auth.loggedInStatus == Status.authenticating) {
            return const SplashLayout();
          }

          return AuthLayout(child: child!);
        },
        redirect: (state) {
          final loggingIn = state.location == '/$loginRoute';
          final notLogged = auth.loggedInStatus != Status.loggedIn &&
              auth.loggedInStatus != Status.authenticating;

          if (notLogged) {
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

BannerRCV _getBannerRCV(BuildContext context, String uid) {
  final bannerProvider = Provider.of<BannerRCVProvider>(context, listen: false);
  final bannerMap = bannerProvider.banners
      .where(
        (b) => b['id'] == uid.toString(),
      )
      .first;
  return BannerRCV.fromMap(bannerMap);
}
