import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/providers/user_form_provider.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';

import 'package:rcv_admin_flutter/src/utils/api.dart';
import 'package:rcv_admin_flutter/src/utils/preferences.dart';

import 'package:rcv_admin_flutter/src/app.dart';

Future<void> main() async {
  final prefs = await Preferences.configurePrefs();
  API.configureDio();
  // Flurorouter.configureRoute();
  runApp(const AppState());
}

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => AuthProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => BannerRCVProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserFormProvider()),
      ],
      child: const MyApp(),
    );
  }
}
