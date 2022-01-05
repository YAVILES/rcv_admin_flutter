import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/providers/user_form_provider.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';

import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

// ignore: must_be_immutable
class UserView extends StatefulWidget {
  String uid;

  UserView({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  User? user;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userFormProvider =
        Provider.of<UserFormProvider>(context, listen: false);
    userProvider.getUser(widget.uid).then((userDB) {
      if (userDB != null) {
        userFormProvider.user = userDB;
        userFormProvider.formKey = GlobalKey<FormState>();

        setState(() => user = userDB);
      } else {
        // NavigationService.navigateTo(context, usersRoute);
      }
    });
  }

  @override
  void dispose() {
    user = null;
    Provider.of<UserFormProvider>(context).user = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: MyProgressIndicator(),
      );
    }

    return CenteredView(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          HeaderView(title: "Usuario"),
          const UserViewBody(),
        ],
      ),
    );
  }
}

class UserViewBody extends StatelessWidget {
  const UserViewBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(250),
      },
      children: [
        TableRow(
          children: [
            _AvatarContainer(),
            const _UserViewForm(),
          ],
        ),
      ],
    );
  }
}

class _UserViewForm extends StatelessWidget {
  const _UserViewForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user;
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Información general',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: userFormProvider.formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: user?.name,
                    onChanged: (value) => {},
                    decoration: const InputDecoration(
                      hintText: 'Ingrese el nombre',
                      labelText: 'Nombre',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: user?.email,
                    onChanged: (value) => {},
                    decoration: const InputDecoration(
                      hintText: 'Ingrese el correo',
                      labelText: 'Correo',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user;
    final userFormProvider = Provider.of<UserFormProvider>(context);
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Perfil',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              children: [
                ClipOval(
                  child: Image.asset('images/img_avatar.png'),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 5),
                    ),
                    child: FloatingActionButton(
                      backgroundColor: Colors.indigo,
                      elevation: 0,
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          // allowedExtensions: ['jpg'],
                          allowMultiple: false,
                        );

                        if (result != null) {
                          PlatformFile file = result.files.first;

                          /*  print(file.name);
                          print(file.bytes);
                          print(file.size);
                          print(file.extension);
                          // print(file.path); */
                          await userFormProvider.uploadImage(
                              'security/user/${user?.id}', file.bytes!);
                        } else {
                          // User canceled the picker
                        }
                      },
                      child: const Icon(Icons.camera_alt_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nombre del usuario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
