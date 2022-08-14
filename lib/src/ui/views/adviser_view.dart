import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/branch_office_model.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/role_model.dart';

import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/role_service.dart';
import 'package:rcv_admin_flutter/src/services/branch_office_service.dart';
import 'package:rcv_admin_flutter/src/services/user_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class AdviserView extends StatefulWidget {
  User? user;
  String? uid;

  AdviserView({
    Key? key,
    this.user,
    this.uid,
  }) : super(key: key);

  @override
  State<AdviserView> createState() => _AdviserViewState();
}

class _AdviserViewState extends State<AdviserView> {
  @override
  Widget build(BuildContext context) {
    if (widget.user != null) {
      return _AdviserViewBody(user: widget.user!);
    } else {
      return FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .getUser(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _AdviserViewBody(user: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _AdviserViewBody extends StatefulWidget {
  User user;

  _AdviserViewBody({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  __AdviserViewBodyState createState() => __AdviserViewBodyState();
}

class __AdviserViewBodyState extends State<_AdviserViewBody> {
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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Asesor ${widget.user.username ?? ''}',
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
                                tag: _user.id ?? 'newAdviser',
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
                                    border: Border.all(
                                        color: Colors.white, width: 5),
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
                                        // Adviser canceled the picker
                                      }
                                    },
                                    child:
                                        const Icon(Icons.camera_alt_outlined),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
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
                                  _saveAdviser(create, userProvider, _user),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese el usuario.',
                                labelText: 'Usuario',
                                constraints:
                                    const BoxConstraints(maxWidth: 350),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Row(
                              children: [
                                FutureBuilder(
                                    future: UserService.getDocumentTypes(),
                                    builder: (_,
                                        AsyncSnapshot<List<Option>?> snapshot) {
                                      return snapshot.connectionState ==
                                              ConnectionState.done
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10,
                                              ),
                                              child: SizedBox(
                                                width: 60,
                                                child: DropdownSearch<Option>(
                                                  items: snapshot.data!,
                                                  selectedItem: Option.fromMap({
                                                    "value": _user.documentType
                                                  }),
                                                  dropdownSearchDecoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Seleccione el tipo de documento",
                                                    labelText:
                                                        "Tipo de Documento",
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            12, 12, 0, 0),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  itemAsString:
                                                      (Option? typeD) =>
                                                          '${typeD!.value}',
                                                  onChanged: (Option? typeD) {
                                                    _user.documentType =
                                                        typeD!.value;
                                                  },
                                                  validator: (Option? typeD) {
                                                    if (typeD == null) {
                                                      return "El tipo de documento es requerido";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                            )
                                          : const MyProgressIndicator();
                                    }),
                                TextFormField(
                                  // readOnly: !create,
                                  initialValue:
                                      _user.identificationNumber ?? '',
                                  onChanged: (value) =>
                                      _user.identificationNumber = value,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'La cedula o el rif es obligatorio';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) =>
                                      _saveAdviser(create, userProvider, _user),
                                  decoration: CustomInputs.buildInputDecoration(
                                    hintText: 'Ingrese la cedula o el rif.',
                                    labelText: 'Cedula o Rif',
                                    constraints:
                                        const BoxConstraints(maxWidth: 350),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _user.name ?? '',
                              onChanged: (value) => _user.name = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El nombre es obligatorio';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  _saveAdviser(create, userProvider, _user),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese el nombre.',
                                labelText: 'Nombre',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue: _user.lastName ?? '',
                              onChanged: (value) => _user.lastName = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El apellido es obligatorio';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  _saveAdviser(create, userProvider, _user),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese el apellido.',
                                labelText: 'Apellido',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              initialValue: _user.email ?? '',
                              onChanged: (value) => _user.email = value,
                              onFieldSubmitted: (value) =>
                                  _saveAdviser(create, userProvider, _user),
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
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              initialValue: _user.emailAlternative ?? '',
                              onChanged: (value) =>
                                  _user.emailAlternative = value,
                              onFieldSubmitted: (value) =>
                                  _saveAdviser(create, userProvider, _user),
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
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _user.phone ?? '',
                              onChanged: (value) => _user.phone = value,
                              onFieldSubmitted: (value) =>
                                  _saveAdviser(create, userProvider, _user),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese el número celular.',
                                labelText: 'Nro. celular',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue: _user.telephone ?? '',
                              onChanged: (value) => _user.telephone = value,
                              onFieldSubmitted: (value) =>
                                  _saveAdviser(create, userProvider, _user),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese el telefono.',
                                labelText: 'Telefono',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              maxLines: null,
                              minLines: 2,
                              keyboardType: TextInputType.multiline,
                              initialValue: _user.direction ?? '',
                              onFieldSubmitted: (value) =>
                                  _saveAdviser(create, userProvider, _user),
                              onChanged: (value) => _user.direction = value,
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese la dirección.',
                                labelText: 'Dirección',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (create)
                            Expanded(
                              child: TextFormField(
                                initialValue: _user.password ?? '',
                                onChanged: (value) => _user.password = value,
                                validator: (value) {
                                  if ((value == null || value.isEmpty) &&
                                      create) {
                                    return 'La contraseña es obligatoria';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) =>
                                    _saveAdviser(create, userProvider, _user),
                                decoration: CustomInputs.buildInputDecoration(
                                  hintText: 'Ingrese la contraseña.',
                                  labelText: 'Contraseña',
                                ),
                              ),
                            ),
                        ],
                      ),
                      FutureBuilder(
                        future: RoleService.getRoles(
                            {'not_paginator': true, 'query': '{id, name}'}),
                        builder: (_, AsyncSnapshot<List<Role>> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? DropdownButtonFormField(
                                  decoration: CustomInputs.buildInputDecoration(
                                    labelText: 'Rol',
                                  ),
                                  hint: const Text("Seleccione el rol"),
                                  // Initial Value
                                  value: userProvider.user!.roles!.isNotEmpty
                                      ? userProvider.user!.roles![0].toString()
                                      : '1',

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: snapshot.data?.map((Role item) {
                                    return DropdownMenuItem(
                                      value: item.id!.toString(),
                                      child: Text(item.name!.toString()),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? value) {
                                    if (value!.isNotEmpty) {
                                      userProvider.user!.roles = [
                                        int.parse(value)
                                      ];
                                    }
                                  },

                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El rol es obligatorio';
                                    }
                                    return null;
                                  },
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      FutureBuilder(
                        future: BranchOfficeService.getAll({
                          'not_paginator': true,
                          'query': '{id, description}',
                          'is_active': true
                        }),
                        builder:
                            (_, AsyncSnapshot<List<BranchOffice>> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? DropdownButtonFormField(
                                  decoration: CustomInputs.buildInputDecoration(
                                    labelText: 'Sucursal',
                                  ),
                                  hint: const Text("Seleccione la sucursal"),
                                  // Initial Value
                                  value: userProvider.user?.branchOffice,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items:
                                      snapshot.data?.map((BranchOffice item) {
                                    return DropdownMenuItem(
                                      value: item.id!.toString(),
                                      child: Text(item.description!.toString()),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? value) {
                                    if (value!.isNotEmpty) {
                                      userProvider.user!.branchOffice = value;
                                    }
                                  },

                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'La sucursal es obligatoria';
                                    }
                                    return null;
                                  },
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 155,
                            child: CustomCheckBox(
                              title: 'Activo',
                              value: _user.isActive ?? true,
                              onChanged: (value) => _user.isActive = value,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _saveAdviser(create, userProvider, _user),
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
      ),
    );
  }

  Future<bool?> _saveAdviser(
    bool create,
    UserProvider userProvider,
    User _user,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await userProvider.newUser(_user, photo, isAdviser: true) ??
              false;
          if (saved) {
            NotificationService.showSnackbarSuccess('${_user.name} creado');
          }
        } else {
          saved = await userProvider.editUser(_user.id!, _user, photo,
                  isAdviser: true) ??
              false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_user.name} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el asesor',
        );
      }
    }
  }
}
