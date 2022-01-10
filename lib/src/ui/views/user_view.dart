import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UserView extends StatefulWidget {
  User? user;
  String? uid;

  UserView({
    Key? key,
    this.user,
    this.uid,
  }) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      return _UserViewBody(user: widget.user!);
    } else {
      return FutureBuilder(
          future: Provider.of<UserProvider>(context, listen: false)
              .getUser(widget.uid ?? ''),
          builder: (_, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? _UserViewBody(user: snapshot.data)
                : const MyProgressIndicator();
          });
    }
  }
}

class _UserViewBody extends StatefulWidget {
  User user;

  _UserViewBody({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  __UserViewBodyState createState() => __UserViewBodyState();
}

class __UserViewBodyState extends State<_UserViewBody> {
  PlatformFile? photo;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).formUserKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User _user = userProvider.user = widget.user;
    final bool create = widget.user.id == null;
    return CenteredView(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          HeaderView(
            title: 'Administración Web',
            subtitle: 'Usuario ${widget.user.username ?? ''}',
          ),
          Column(
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
                              tag: _user.id ?? 'newUser',
                              child: ClipOval(
                                child: (photo?.bytes != null)
                                    ? Image.memory(
                                        Uint8List.fromList(photo!.bytes!))
                                    : _user.photo != null
                                        ? Image.network(_user.photo!)
                                        : Image.asset(
                                            'assets/images/img_avatar.png'),
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
                                  border:
                                      Border.all(color: Colors.white, width: 5),
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
                                      setState(
                                          () => photo = result.files.first);
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
                        _user.username ?? '',
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
              Form(
                key: userProvider.formUserKey,
                child: Wrap(
                  children: [
                    TextFormField(
                      readOnly: !create,
                      initialValue: _user.username ?? '',
                      onChanged: (value) => _user.username = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El usuario es obligatorio';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el usuario.',
                        labelText: 'Usuario',
                      ),
                    ),
                    TextFormField(
                      initialValue: _user.name ?? '',
                      onChanged: (value) => _user.name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el nombre.',
                        labelText: 'Nombre',
                      ),
                    ),
                    TextFormField(
                      initialValue: _user.lastName ?? '',
                      onChanged: (value) => _user.lastName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El apellido es obligatorio';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el apellido.',
                        labelText: 'Apellido',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: _user.email ?? '',
                      onChanged: (value) => _user.email = value,
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      validator: (value) {
                        final valid = EmailValidator.validate(value!);
                        if (!valid) {
                          return 'ingrese un correo valido';
                        }

                        return null;
                      },
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el correo.',
                        labelText: 'Correo',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: _user.emailAlternative ?? '',
                      onChanged: (value) => _user.emailAlternative = value,
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final valid = EmailValidator.validate(value);
                          if (!valid) {
                            return 'ingrese un correo valido';
                          }
                        }
                        return null;
                      },
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el correo alternativo.',
                        labelText: 'Correo alternativo',
                      ),
                    ),
                    TextFormField(
                      maxLines: null,
                      minLines: 2,
                      keyboardType: TextInputType.multiline,
                      initialValue: _user.direction ?? '',
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      onChanged: (value) => _user.direction = value,
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese la dirección.',
                        labelText: 'Dirección',
                      ),
                    ),
                    TextFormField(
                      initialValue: _user.phone ?? '',
                      onChanged: (value) => _user.phone = value,
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el número celular.',
                        labelText: 'Nro. celular',
                      ),
                    ),
                    TextFormField(
                      initialValue: _user.telephone ?? '',
                      onChanged: (value) => _user.telephone = value,
                      onFieldSubmitted: (value) =>
                          _saveUser(create, userProvider, _user),
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el telefono.',
                        labelText: 'Telefono',
                      ),
                    ),
                    if (create)
                      TextFormField(
                        initialValue: _user.password ?? '',
                        onChanged: (value) => _user.password = value,
                        validator: (value) {
                          if ((value == null || value.isEmpty) && create) {
                            return 'La contraseña es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveUser(create, userProvider, _user),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la contraseña.',
                          labelText: 'Contraseña',
                        ),
                      ),
                    CustomCheckBox(
                      title: 'Es personal',
                      value: _user.isStaff ?? true,
                      onChanged: (value) => _user.isStaff = value,
                    ),
                    CustomCheckBox(
                      title: 'Activar',
                      titleActive: 'Inactivar',
                      value: _user.isActive ?? true,
                      onChanged: (value) => _user.isActive = value,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: CustomButtonPrimary(
                        onPressed: () => _saveUser(create, userProvider, _user),
                        title: 'Guardar',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> _saveUser(
    bool create,
    UserProvider userProvider,
    User _user,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await userProvider.newUser(_user, photo) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess('${_user.name} creado');
          }
        } else {
          saved = await userProvider.editUser(_user.id!, _user, photo) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_user.name} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.backTo(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el user',
        );
      }
    }
  }
}
