import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

class SplashLayout extends StatelessWidget {
  const SplashLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            MyProgressIndicator(),
            SizedBox(height: 20),
            Text("Verificando Sesión"),
          ],
        ),
      ),
    );
  }
}
