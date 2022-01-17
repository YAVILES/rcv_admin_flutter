import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _router = RouterGoRouter.generateRoute(context);
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: 'Admin RC871',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
            ),
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.green),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Colors.green,
        ),
      ),
      scaffoldMessengerKey: NotificationService.messengerKey,
      /*      builder: (context, child) {
        AuthProvider auth = Provider.of<AuthProvider>(context);
        if (auth.loggedInStatus == Status.loggedIn) {
          return DashBoardLayout(child: child!);
        }

        if (auth.loggedInStatus == Status.authenticating) {
          return const SplashLayout();
        }

        return AuthLayout(child: child!);
      }, */
    );
  }
}
