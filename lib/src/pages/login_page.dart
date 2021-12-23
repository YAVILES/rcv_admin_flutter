import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/models/user.dart';
import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.context, {Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  BuildContext context;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      body: Stack(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Image.asset(
              "assets/images/rc871.jpg",
              height: 200,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -40),
            child: Center(
              child: CardLogin(),
            ),
          )
        ],
      ),
    );
  }
}

class CardLogin extends StatefulWidget {
  const CardLogin({Key? key}) : super(key: key);

  @override
  _CardLoginState createState() => _CardLoginState();
}

class _CardLoginState extends State<CardLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String password = "";
  String username = "";
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth > 600 ? 500 : double.infinity,
            child: Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 240,
                  bottom: 20,
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Inicie sesión en su cuenta para continuar",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Usuario",
                          icon: Icon(Icons.person),
                        ),
                        onSaved: (value) => {username = value!},
                        validator: (value) {
                          if (value == "") {
                            return "EL usuario es requerido";
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Contraseña",
                          icon: Icon(
                            Icons.password,
                          ),
                        ),
                        onSaved: (value) => {password = value!},
                        validator: (value) {
                          if (value == "") {
                            return "La contraseña es requerida";
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      TextButton(
                        child: const Text("¿Se te olvidó la contraseña?"),
                        onPressed: () => _showChagePassword(),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _login(userProvider, auth),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Iniciar Sesión"),
                            if (_loading)
                              Container(
                                height: 20,
                                width: 20,
                                margin: const EdgeInsets.only(left: 20),
                                child: const CircularProgressIndicator(),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showChagePassword() {}

  void _login(UserProvider userProvider, AuthProvider auth) async {
    if (!_loading) {
      setState(() {
        _loading = true;
        _errorMessage = "";
      });
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(username, password);

        successfulMessage.then((response) async {
          if (response['status']) {
            User user = response['user'];
            await Provider.of<UserProvider>(context, listen: false)
                .setUser(user);
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Flushbar(
              title: "Failed Login",
              message: response.toString(),
              duration: const Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        setState(() {
          _loading = false;
          _errorMessage = "";
        });
      }
    }
  }
}
