import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/models/branch_office_model.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';

import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/providers/branch_office_provider.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/auth/auth_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/splash/splash_layout.dart';
import 'package:rcv_admin_flutter/src/ui/views/banner_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/banners_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/branch_office_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/branch_offices_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/home_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/login_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/not_found_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/user_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/users_view.dart';

// Código Go RouterGoRouter

class RouterGoRouter {
  static GoRouter generateRoute(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    return GoRouter(
      // debugLogDiagnostics: true,
      // initialLocation: '/users/user',
      routes: [
        GoRoute(
          name: rootRoute,
          path: rootRoute,
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

        //Banners
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
              path: bannerRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: BannerView(),
                );
              },
            ),
            GoRoute(
              name: bannerDetailRoute,
              path: '$bannerRoute/:id',
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

        // Users
        GoRoute(
          name: usersRoute,
          path: '/$usersRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const UsersView(),
          ),
          routes: [
            GoRoute(
              name: userRoute,
              path: userRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: UserView(),
                );
              },
            ),
            GoRoute(
              name: userDetailRoute,
              path: '$userRoute/:id',
              pageBuilder: (context, state) {
                User user = _getUser(
                  context,
                  state.params['id'].toString(),
                );
                return MaterialPage(
                  key: state.pageKey,
                  child: UserView(user: user),
                  //child: UserView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
        ),

        // Branch Offices
        GoRoute(
          name: branchOfficesRoute,
          path: '/$branchOfficesRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const BranchOfficesView(),
          ),
          routes: [
            GoRoute(
              name: branchOfficeRoute,
              path: branchOfficeRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: BranchOfficeView(),
                );
              },
            ),
            GoRoute(
              name: branchOfficeDetailRoute,
              path: '$branchOfficeRoute/:id',
              pageBuilder: (context, state) {
                BranchOffice branchOffice = _getBranchOffice(
                  context,
                  state.params['id'].toString(),
                );
                return MaterialPage(
                  key: state.pageKey,
                  child: BranchOfficeView(branchOffice: branchOffice),
                  // child: BranchOfficeView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
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
      },
    );
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

BranchOffice _getBranchOffice(BuildContext context, String uid) {
  final branchOfficeMap =
      Provider.of<BranchOfficeProvider>(context, listen: false)
          .branchOffices
          .where(
            (b) => b['id'] == uid.toString(),
          )
          .first;
  return BranchOffice.fromMap(branchOfficeMap);
}

User _getUser(BuildContext context, String uid) {
  final userMap = Provider.of<UserProvider>(context, listen: false)
      .users
      .where(
        (b) => b['id'] == uid.toString(),
      )
      .first;
  return User.fromMap(userMap);
}
