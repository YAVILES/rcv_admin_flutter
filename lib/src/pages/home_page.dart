import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/user.dart';
import 'package:rcv_admin_flutter/src/pages/banner_page.dart';

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
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              return Scaffold(
                drawer: Drawer(
                    backgroundColor: Colors.white,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        if (snapshot.hasError) Text('Error: ${snapshot.error}'),
                        _getDrawerHeader(snapshot),
                        ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.admin_panel_settings),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('Administración de Sistema'),
                              )
                            ],
                          ),
                          children: const [],
                        ),
                        ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.web_asset),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('Administración Web'),
                              )
                            ],
                          ),
                          children: [
                            ListTile(
                              title: const Text('Banners'),
                              leading: const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(Icons.flaky_rounded),
                              ),
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/banner');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ListTile(
                          title: const Text('Cerrar Sesión'),
                          leading: const Icon(Icons.logout),
                          onTap: () {
                            UserPreferences().removeUser();
                            Navigator.of(context).pushReplacementNamed('/');
                            // Update the state of the app.
                            // ...
                          },
                        ),
                      ],
                    )),
                appBar: AppBar(
                  title: Text(snapshot.data?.name ?? ""),
                ),
                body: Center(
                    child: ElevatedButton(
                  child: const Text("TEST"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const BannersPage();
                      }),
                    );
                  },
                )),
              );
          }
        });
  }

  _getDrawerHeader(snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return const CircularProgressIndicator();
      default:
        return UserAccountsDrawerHeader(
          accountName: Text("${snapshot.data?.name}"),
          accountEmail: Text("${snapshot.data?.email}"),
          currentAccountPicture: Image.asset('assets/images/rc871.jpg'),
          otherAccountsPictures: const [
            FlutterLogo(),
          ],
          onDetailsPressed: () {},
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.yellow],
            ),
          ),
        );

      /*              DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          FlutterLogo(
                            size: 100,
                          ),
                          Text('Drawer Header'),
                        ],
                      ),
                    ), */
    }
  }
}
