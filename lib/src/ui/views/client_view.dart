import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/client_model.dart';
import 'package:rcv_admin_flutter/src/providers/client_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ClientView extends StatefulWidget {
  Client? client;
  String? uid;
  bool? modal;
  ClientView({Key? key, this.client, this.uid, this.modal = false})
      : super(key: key);

  @override
  State<ClientView> createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  @override
  Widget build(BuildContext context) {
    if (widget.client != null) {
      return _ClientViewBody(client: widget.client!, modal: widget.modal);
    } else {
      return FutureBuilder(
        future: Provider.of<ClientProvider>(context, listen: false)
            .getClient(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _ClientViewBody(client: snapshot.data, modal: widget.modal)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _ClientViewBody extends StatefulWidget {
  Client client;
  bool? modal;
  _ClientViewBody({
    Key? key,
    required this.client,
    this.modal = false,
  }) : super(key: key);

  @override
  __ClientViewBodyState createState() => __ClientViewBodyState();
}

class __ClientViewBodyState extends State<_ClientViewBody> {
  PlatformFile? photo;

  @override
  void initState() {
    Provider.of<ClientProvider>(context, listen: false).formClientKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ClientProvider clientProvider = Provider.of<ClientProvider>(context);
    Client _client = clientProvider.client = widget.client;
    final bool create = widget.client.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Cliente ${widget.client.username ?? ''}',
              modal: widget.modal,
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
                                tag: _client.id ?? 'newClient',
                                child: ClipOval(
                                  child: (photo?.bytes != null)
                                      ? Image.memory(
                                          Uint8List.fromList(photo!.bytes!))
                                      : _client.photo != null
                                          ? Image.network(_client.photo!)
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
                                        // Client canceled the picker
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
                          _client.username ?? '',
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
                  key: clientProvider.formClientKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: !create,
                              initialValue: _client.username ?? '',
                              onChanged: (value) => _client.username = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El usuario es obligatorio';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
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
                            child: TextFormField(
                              readOnly: !create,
                              initialValue: _client.identificationNumber ?? '',
                              onChanged: (value) =>
                                  _client.identificationNumber = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'La cedula o el rif es obligatorio';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese la cedula o el rif.',
                                labelText: 'Cedula o Rif',
                                constraints:
                                    const BoxConstraints(maxWidth: 350),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _client.name ?? '',
                              onChanged: (value) => _client.name = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El nombre es obligatorio';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese el nombre.',
                                labelText: 'Nombre',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue: _client.lastName ?? '',
                              onChanged: (value) => _client.lastName = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El apellido es obligatorio';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
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
                              initialValue: _client.email ?? '',
                              onChanged: (value) => _client.email = value,
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
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
                              initialValue: _client.emailAlternative ?? '',
                              onChanged: (value) =>
                                  _client.emailAlternative = value,
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
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
                              initialValue: _client.phone ?? '',
                              onChanged: (value) => _client.phone = value,
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Ingrese el número celular.',
                                labelText: 'Nro. celular',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue: _client.telephone ?? '',
                              onChanged: (value) => _client.telephone = value,
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
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
                              initialValue: _client.direction ?? '',
                              onFieldSubmitted: (value) =>
                                  _saveClient(create, clientProvider, _client),
                              onChanged: (value) => _client.direction = value,
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
                                initialValue: _client.password ?? '',
                                onChanged: (value) => _client.password = value,
                                validator: (value) {
                                  if ((value == null || value.isEmpty) &&
                                      create) {
                                    return 'La contraseña es obligatoria';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) => _saveClient(
                                    create, clientProvider, _client),
                                decoration: CustomInputs.buildInputDecoration(
                                  hintText: 'Ingrese la contraseña.',
                                  labelText: 'Contraseña',
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 155,
                            child: CustomCheckBox(
                              title: 'Activo',
                              value: _client.isActive ?? true,
                              onChanged: (value) => _client.isActive = value,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _saveClient(create, clientProvider, _client),
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

  Future<bool?> _saveClient(
    bool create,
    ClientProvider clientProvider,
    Client _client,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await clientProvider.newClient(_client, photo) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess('${_client.name} creado');
          }
        } else {
          saved =
              await clientProvider.editClient(_client.id!, _client, photo) ??
                  false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_client.name} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el client',
        );
      }
    }
  }
}
