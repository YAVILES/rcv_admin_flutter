import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class UserView extends StatefulWidget {
  User? user;

  UserView({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).user =
        widget.user ?? User();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CenteredView(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          HeaderView(
            title: 'Administración Web',
            subtitle: 'Usuario ${widget.user?.username ?? ''}',
          ),
          const _UserForm(),
        ],
      ),
    );
  }
}

class _UserForm extends StatefulWidget {
  const _UserForm({Key? key}) : super(key: key);

  @override
  State<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<_UserForm> {
  PlatformFile? photo;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final bool create = userProvider.user!.id == null;

    return Column(
      children: [
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    children: [
                      Hero(
                        tag: userProvider.user?.id ?? 'newUser',
                        child: ClipOval(
                          child: (photo?.bytes != null)
                              ? Image.memory(Uint8List.fromList(photo!.bytes!))
                              : userProvider.user?.photo != null
                                  ? Image.network(userProvider.user!.photo!)
                                  : Image.asset('assets/images/img_avatar.png'),
                        ),
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
                                setState(() => photo = result.files.first);
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
                Text(
                  userProvider.user?.name ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          initialValue: userProvider.user?.username,
          onChanged: (value) => userProvider.user!.username = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese el Usuario',
            labelText: 'Usuario',
          ),
        ),
        TextFormField(
          initialValue: userProvider.user?.name,
          onChanged: (value) => userProvider.user!.name = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese el nombre',
            labelText: 'Nombre',
          ),
        ),
        TextFormField(
          initialValue: userProvider.user!.lastName,
          onChanged: (value) => userProvider.user!.lastName = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese el apellido',
            labelText: 'Apellido',
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          initialValue: userProvider.user!.email,
          onChanged: (value) => userProvider.user!.email = value,
          onFieldSubmitted: (value) {},
          validator: (value) {
            final valid = EmailValidator.validate(value!);
            if (!valid) {
              return 'ingrese un correo valido';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Ingrese el correo',
            labelText: 'Correo',
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          initialValue: userProvider.user!.emailAlternative,
          onChanged: (value) => userProvider.user!.emailAlternative = value,
          onFieldSubmitted: (value) {},
          validator: (value) {
            if (value != null) {
              final valid = EmailValidator.validate(value);
              if (!valid) {
                return 'ingrese un correo valido';
              }
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: 'Ingrese el correo alternativo',
            labelText: 'Correo alternativo',
          ),
        ),
        TextFormField(
          maxLines: null,
          minLines: 2,
          keyboardType: TextInputType.multiline,
          initialValue: userProvider.user!.direction,
          onChanged: (value) => userProvider.user!.direction = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese la direccion',
            labelText: 'Dirección',
          ),
        ),
        TextFormField(
          initialValue: userProvider.user!.phone,
          onChanged: (value) => userProvider.user!.phone = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese el nro. celular',
            labelText: 'Nro. celular',
          ),
        ),
        TextFormField(
          initialValue: userProvider.user!.telephone,
          onChanged: (value) => userProvider.user!.telephone = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese el telefono',
            labelText: 'Telefono',
          ),
        ),
        if (create)
          TextFormField(
            initialValue: userProvider.user!.password,
            onChanged: (value) => userProvider.user!.password = value,
            decoration: const InputDecoration(
              hintText: 'Ingrese la contraseña',
              labelText: 'Contraseña',
            ),
          ),
        CustomCheckBox(
          value: userProvider.user!.isActive ?? true,
          onChanged: (value) => userProvider.user!.isActive = value,
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: CustomButtonPrimary(
            onPressed: () async {
              try {
                if (create) {
                  await userProvider.newUser(userProvider.user!, photo);
                  NotificationService.showSnackbarSuccess(
                      '${userProvider.user!.name} creado');
                } else {
                  await userProvider.editUser(
                      userProvider.user!.id!, userProvider.user!, photo);
                  NotificationService.showSnackbarSuccess(
                    '${userProvider.user!.name} actualizado',
                  );
                }
                NavigationService.backTo(context);
              } catch (e) {
                print(e);
                NotificationService.showSnackbarError(
                  'No se pudo guardar el user',
                );
              }
            },
            title: 'Guardar',
          ),
        ),
      ],
    );
  }
}
