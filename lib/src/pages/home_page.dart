import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/user.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<User> getUserData() => UserPreferences().getUser();

  // This widget is the home page of your application. It is stateful, meaning
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserData(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          return Scaffold(
            drawer: Drawer(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            ),
            appBar: AppBar(
              title: Text(snapshot.data?.name ?? ""),
            ),
            body: const Center(
              child: Text('Hello World'),
            ),
          );
        });
  }
}
