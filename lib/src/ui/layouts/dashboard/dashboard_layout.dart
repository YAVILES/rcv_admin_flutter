import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/nav_drawer/navigation_drawer.dart';
import 'package:rcv_admin_flutter/src/providers/nav_drawer_provider.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/navbar_avatar.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/notification_indicator.dart';

class DashBoardLayout extends StatefulWidget {
  const DashBoardLayout({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  State<DashBoardLayout> createState() => _DashBoardLayoutState();
}

class _DashBoardLayoutState extends State<DashBoardLayout> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavDrawerProvider(),
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) {
              return Scaffold(
                key: NavDrawerProvider.scaffoldKey,
                drawer: const NavigationDrawer(),
                appBar: AppBar(
                  title: Row(
                    children: const [
                      /*                
                      if (NavDrawerProvider.activeBackButton == true) ...[
                        BackButton(
                          onPressed: ()  {
                            NavigationService.back(null);
                          },
                        ), 
                        const SizedBox(width: 25),
                        
                      ],
                      */
                      Text("RCV 871"),
                    ],
                  ),
                  elevation: 0,
                  actions: const [
                    // NotificationIndicator(),
                    SizedBox(width: 10),
                    NavbarAvatar(),
                    SizedBox(width: 10),
                  ],
                ),
                backgroundColor: Colors.white,
                body: widget.child,
              );
            },
          ),
        ],
      ),
    );
  }
}
