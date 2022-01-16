import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/nav_drawer/drawer_module.dart';
import 'package:rcv_admin_flutter/src/components/nav_drawer/drawer_item.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/nav_drawer_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final navDrawerProvider = Provider.of<NavDrawerProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _getDrawerHeader(user: authProvider.user),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              navDrawerProvider.setActiveBackButton(false);
              navigateTo(context, dashBoardRoute);
            },
          ),
          const SizedBox(height: 15),
          DrawerItem(
            title: 'Administración de Sistema',
            icon: Icons.system_update_outlined,
            navigationPath: dashBoardRoute,
            children: [
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == usersRoute,
                title: "Usuarios",
                navigationPath: bannersRoute,
                icon: Icons.supervised_user_circle_rounded,
                onPressed: () {
                  navDrawerProvider.setActiveBackButton(true);
                  navigateTo(context, usersRoute);
                },
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == rolesRoute,
                title: "Roles",
                navigationPath: rolesRoute,
                icon: Icons.accessibility_rounded,
                onPressed: () => navigateTo(context, rolesRoute),
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == branchOfficesRoute,
                title: "Sucursales",
                navigationPath: branchOfficesRoute,
                icon: Icons.location_city_outlined,
                onPressed: () => navigateTo(context, branchOfficesRoute),
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == usesRoute,
                title: "Usos",
                navigationPath: usesRoute,
                icon: Icons.verified_outlined,
                onPressed: () => navigateTo(context, usesRoute),
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == plansRoute,
                title: "Planes",
                navigationPath: plansRoute,
                icon: Icons.place_outlined,
                onPressed: () => navigateTo(context, plansRoute),
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == coveragesRoute,
                title: "Coberturas",
                navigationPath: coveragesRoute,
                icon: Icons.local_convenience_store_sharp,
                onPressed: () => navigateTo(context, coveragesRoute),
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == premiumsRoute,
                title: "Gestión de Primas",
                navigationPath: premiumsRoute,
                icon: Icons.price_change_outlined,
                onPressed: () => navigateTo(context, premiumsRoute),
              ),
            ],
          ),
          DrawerItem(
            title: 'Administración Web',
            icon: Icons.web_outlined,
            navigationPath: dashBoardRoute,
            children: [
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == bannersRoute,
                title: "Banners",
                navigationPath: bannersRoute,
                icon: Icons.nature,
                onPressed: () => navigateTo(context, bannersRoute),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ListTile(
            title: const Text('Cerrar Sesión'),
            leading: const Icon(Icons.logout),
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              NavDrawerProvider.scaffoldKey.currentState?.openEndDrawer();
              // navigateTo(context, loginRoute);
            },
          ),
        ],
      ),
    );
  }

  _getDrawerHeader({User? user}) {
    return UserAccountsDrawerHeader(
      accountName: Text(user!.name ?? ''),
      accountEmail: Text(user.email ?? ''),
      currentAccountPicture: Image.asset('assets/images/rc871.jpg'),
      otherAccountsPictures: [
        ClipOval(child: Image.asset('assets/images/img_avatar.png')),
      ],
      onDetailsPressed: () {},
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.yellow],
        ),
      ),
    );
  }

  navigateTo(BuildContext context, String nameRoute) {
    NavigationService.navigateTo(context, nameRoute, null);
    NavDrawerProvider.scaffoldKey.currentState?.openEndDrawer();
  }
}
