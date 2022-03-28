import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/models/branch_office_model.dart';
import 'package:rcv_admin_flutter/src/models/role_model.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';

import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/providers/branch_office_provider.dart';
import 'package:rcv_admin_flutter/src/providers/role_provider.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/auth/auth_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:rcv_admin_flutter/src/ui/layouts/splash/splash_layout.dart';
import 'package:rcv_admin_flutter/src/ui/views/banner_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/banners_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/branch_office_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/branch_offices_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/client_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/clients_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/coverage_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/coverages_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/home_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/login_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/mark_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/marks_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/model_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/models_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/not_found_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/plan_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/plans_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/premiums_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/role_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/roles_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/use_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/user_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/users_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/uses_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/vehicle_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/vehicles_view.dart';

// Código Go RouterGoRouter

class RouterGoRouter {
  static GoRouter generateRoute(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    return GoRouter(
      // debugLogDiagnostics: true,
      // initialLocation: '/banners',
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

        // Roles
        GoRoute(
          name: rolesRoute,
          path: '/$rolesRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const RolesView(),
          ),
          routes: [
            GoRoute(
              name: roleRoute,
              path: roleRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: RoleView(),
                );
              },
            ),
            GoRoute(
              name: roleDetailRoute,
              path: '$roleRoute/:id',
              pageBuilder: (context, state) {
                Role role = _getRole(
                  context,
                  state.params['id'].toString(),
                );
                return MaterialPage(
                  key: state.pageKey,
                  child: RoleView(role: role),
                  // child: BranchOfficeView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
        ),

        // Usos
        GoRoute(
          name: usesRoute,
          path: '/$usesRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const UsesView(),
          ),
          routes: [
            GoRoute(
              name: useRoute,
              path: useRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: UseView(),
                );
              },
            ),
            GoRoute(
              name: useDetailRoute,
              path: '$useRoute/:id',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: UseView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
        ),

        // Planes
        GoRoute(
          name: plansRoute,
          path: '/$plansRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const PlansView(),
          ),
          routes: [
            GoRoute(
              name: planRoute,
              path: planRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: PlanView(),
                );
              },
            ),
            GoRoute(
              name: planDetailRoute,
              path: '$planRoute/:id',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: PlanView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
        ),

        // Coberturas
        GoRoute(
          name: coveragesRoute,
          path: '/$coveragesRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const CoveragesView(),
          ),
          routes: [
            GoRoute(
              name: coverageRoute,
              path: coverageRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: CoverageView(),
                );
              },
            ),
            GoRoute(
              name: coverageDetailRoute,
              path: '$coverageRoute/:id',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: CoverageView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
        ),

        // Primas
        GoRoute(
          name: premiumsRoute,
          path: '/$premiumsRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const PremiumsView(),
          ),
        ),

        // Clients
        GoRoute(
            name: clientsRoute,
            path: '/$clientsRoute',
            pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const ClientsView(),
                ),
            routes: [
              GoRoute(
                name: clientRoute,
                path: clientRoute,
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    child: ClientView(),
                  );
                },
              ),
              GoRoute(
                name: clientDetailRoute,
                path: '$clientsRoute/:id',
                pageBuilder: (context, state) {
                  return MaterialPage(
                    key: state.pageKey,
                    child: ClientView(uid: state.params['id'].toString()),
                  );
                },
              ),
            ]),

        // Marks
        GoRoute(
          name: marksRoute,
          path: '/$marksRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const MarksView(),
          ),
          routes: [
            GoRoute(
              name: markRoute,
              path: markRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: MarkView(),
                );
              },
            ),
            GoRoute(
              name: markDetailRoute,
              path: '$marksRoute/:id',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: MarkView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
        ),

        // Models
        GoRoute(
          name: modelsRoute,
          path: '/$modelsRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const ModelsView(),
          ),
          routes: [
            GoRoute(
              name: modelRoute,
              path: modelRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: ModelView(),
                );
              },
            ),
            GoRoute(
              name: modelDetailRoute,
              path: '$modelsRoute/:id',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: ModelView(uid: state.params['id'].toString()),
                );
              },
            ),
          ],
        ),

        // Models
        GoRoute(
          name: vehiclesRoute,
          path: '/$vehiclesRoute',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const VehiclesView(),
          ),
          routes: [
            GoRoute(
              name: vehicleRoute,
              path: vehicleRoute,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: VehicleView(),
                );
              },
            ),
            GoRoute(
              name: vehicleDetailRoute,
              path: '$vehiclesRoute/:id',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: VehicleView(uid: state.params['id'].toString()),
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

Role _getRole(BuildContext context, String uid) {
  final roleMap = Provider.of<RoleProvider>(context, listen: false)
      .roles
      .where(
        (b) => b['id'].toString() == uid,
      )
      .first;
  return Role.fromMap(roleMap);
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
