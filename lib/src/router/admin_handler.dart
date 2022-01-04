import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/ui/views/home_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/login_view.dart';
import 'package:rcv_admin_flutter/src/utils/preferences.dart';

class AdminHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context!);

    if (authProvider.loggedInStatus == Status.loggedIn ||
        Preferences.getToken() != null) {
      return const HomeView();
    } else {
      return const LoginView();
    }
  });
}
