import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/nav_drawer/drawer_module.dart';
import 'package:rcv_admin_flutter/src/components/nav_drawer/drawer_item.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/models/workflow_model.dart';
import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/nav_drawer_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/workflow_service.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final navDrawerProvider = Provider.of<NavDrawerProvider>(context);
    List<Widget> menus = [];
    var wf = groupBy(authProvider.user!.rolesDisplay![0].workflowsDisplay!,
        (Workflow oj) => oj.moduleDisplay!.title);
    for (var key in wf.keys) {
      menus.add(DrawerItem(
        title: key.toString(),
        icon: WorkFlowService.iconDataMenuWorkflow(wf[key]![0].icon!),
        navigationPath: bannersRoute,
        children: [
          ...wf[key]!
              .map(
                (e) => NavBarItem(
                  isActive: navDrawerProvider.routeCurrent == e.url.toString(),
                  title: e.title.toString(),
                  navigationPath: e.url.toString(),
                  icon: WorkFlowService.iconDataMenuWorkflow(e.icon!),
                  onPressed: () => navigateTo(context, e.url.toString()),
                ),
              )
              .toList()
        ],
      ));
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _getDrawerHeader(user: authProvider.user),
          ListTile(
            title: const Text('Inicio'),
            leading: const Icon(Icons.home),
            onTap: () {
              navDrawerProvider.setActiveBackButton(false);
              navigateTo(context, dashBoardRoute);
            },
          ),
          const SizedBox(height: 15),
          ...menus,
          /*   DrawerItem(
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
                icon: Icons.local_offer_outlined,
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
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == clientsRoute,
                title: "Gestión de Clientes",
                navigationPath: clientsRoute,
                icon: Icons.supervised_user_circle_outlined,
                onPressed: () {
                  navDrawerProvider.setActiveBackButton(true);
                  navigateTo(context, clientsRoute);
                },
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
          DrawerItem(
            title: 'Administración de Vehículos',
            icon: Icons.car_rental_outlined,
            navigationPath: vehiclesRoute,
            children: [
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == marksRoute,
                title: "Marcas",
                navigationPath: marksRoute,
                icon: Icons.image_outlined,
                onPressed: () => navigateTo(context, marksRoute),
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == modelsRoute,
                title: "Modelos",
                navigationPath: modelsRoute,
                icon: Icons.model_training_outlined,
                onPressed: () => navigateTo(context, modelsRoute),
              ),
              NavBarItem(
                isActive: navDrawerProvider.routeCurrent == vehiclesRoute,
                title: "Vehículos",
                navigationPath: vehiclesRoute,
                icon: Icons.car_repair_outlined,
                onPressed: () => navigateTo(context, vehiclesRoute),
              ),
            ],
          ),
           */
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
        ClipOval(
          child: user.photo != null
              ? Image.network(user.photo!)
              : Image.asset('assets/images/img_avatar.png'),
        ),
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
