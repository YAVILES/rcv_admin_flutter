import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/providers/auth_provider.dart';
import 'package:rcv_admin_flutter/src/providers/login_form_provider.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 25),
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
            child: const Center(
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
  @override
  Widget build(BuildContext context) {
    LoginFormProvider loginFormProvider =
        Provider.of<LoginFormProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: SizedBox(
            width: constraints.maxWidth > 600 ? 500 : double.infinity,
            child: Form(
              key: loginFormProvider.formLoginKey,
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
                    horizontal: 35,
                    vertical: 30,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 25),
                      TextFormField(
                        // keyboardType: TextInputType.text,
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el usuario',
                          icon: Icons.person,
                          labelText: 'Usuario',
                        ),
                        onFieldSubmitted: (value) => onFormSubmit(
                            context, loginFormProvider, authProvider),
                        onSaved: (value) => loginFormProvider.username = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "EL usuario es requerido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        obscureText: true,
                        // keyboardType: TextInputType.visiblePassword,
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la contraseña',
                          icon: Icons.password,
                          labelText: 'Contraseña',
                        ),
                        onFieldSubmitted: (_) => onFormSubmit(
                            context, loginFormProvider, authProvider),
                        onSaved: (value) => loginFormProvider.password = value!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "La contraseña es requerido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (loginFormProvider.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            loginFormProvider.errorMessage,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 15),
                      if (!loginFormProvider.loading)
                        CustomButtonPrimary(
                          title: "Iniciar",
                          onPressed: () => onFormSubmit(
                              context, loginFormProvider, authProvider),
                        ),
                      const SizedBox(height: 15),
                      TextButton(
                        child: const Text("¿Se te olvidó la contraseña?"),
                        onPressed: () => {},
                      ),
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

  Future<void> onFormSubmit(BuildContext context,
      LoginFormProvider loginFormProvider, AuthProvider authProvider) async {
    loginFormProvider.saveForm();
    await authProvider.login(
        context, loginFormProvider.username, loginFormProvider.password);
  }
}
