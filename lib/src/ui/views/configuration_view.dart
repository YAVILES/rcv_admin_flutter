import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/configuration_model.dart';
import 'package:rcv_admin_flutter/src/models/user_model.dart';
import 'package:rcv_admin_flutter/src/providers/configuration_provider.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/user_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ConfigurationView extends StatefulWidget {
  ConfigurationView({Key? key, this.modal = false}) : super(key: key);

  bool? modal;
  @override
  State<ConfigurationView> createState() => _ConfigurationViewState();
}

class _ConfigurationViewState extends State<ConfigurationView> {
  @override
  void initState() {
    Provider.of<ConfigurationProvider>(context, listen: false)
        .formConfigurationKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConfigurationProvider configurationProvider =
        Provider.of<ConfigurationProvider>(context, listen: false);
    return FutureBuilder(
        future: configurationProvider.getConfigs(),
        builder: (context, AsyncSnapshot<List<Configuration>?> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? ConfigurationBody(data: snapshot.data)
              : const MyProgressIndicator();
        });
  }
}

class ConfigurationBody extends StatelessWidget {
  ConfigurationBody({
    Key? key,
    this.modal = false,
    this.data,
  }) : super(key: key);
  bool? modal;
  List<Configuration>? data;

  @override
  Widget build(BuildContext context) {
    ConfigurationProvider configurationProvider =
        Provider.of<ConfigurationProvider>(context, listen: false);
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Configuración',
              modal: modal,
            ),
            Consumer<ConfigurationProvider>(builder: (context, obj, child) {
              return Form(
                key: configurationProvider.formConfigurationKey,
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        ...obj.configurations.map((conf) {
                          if (conf.key == 'CHANGE_FACTOR') {
                            return SizedBox(
                              width: 320,
                              child: Row(
                                children: [
                                  Text(conf.helpText!),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: conf.value.toString(),
                                      onChanged: (value) =>
                                          conf.value = double.parse(value),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'El factor de cambio es obligatorio';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) => {
                                        _saveConfig(configurationProvider, conf)
                                      },
                                      // _saveConfiguration(conf),
                                      decoration:
                                          CustomInputs.buildInputDecoration(
                                        hintText:
                                            'Ingrese el factor de cambio.',
                                        labelText: conf.helpText!,
                                        constraints:
                                            const BoxConstraints(maxWidth: 140),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            );
                          }
                          if (conf.key == 'ADVISER_DEFAULT_ID') {
                            return FutureBuilder(
                              future: UserService.getUsers({
                                'not_paginator': true,
                                'is_staff': true,
                                'is_adviser': true,
                                'query':
                                    '{id, full_name, identification_number}'
                              }),
                              builder:
                                  (_, AsyncSnapshot<List<User>?> snapshot) {
                                return snapshot.connectionState ==
                                        ConnectionState.done
                                    ? (snapshot.data!.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: DropdownSearch<User>(
                                              mode: Mode.MENU,
                                              items: snapshot.data,
                                              showSearchBox: true,
                                              selectedItem: snapshot.data
                                                  ?.where((user) =>
                                                      user.id == conf.value)
                                                  .first,
                                              dropdownSearchDecoration:
                                                  const InputDecoration(
                                                hintText:
                                                    "Seleccione el asesor por defecto",
                                                labelText: "Asesor por defecto",
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        12, 12, 0, 0),
                                                border: OutlineInputBorder(),
                                              ),
                                              itemAsString: (User? user) =>
                                                  '${user!.fullName!} ${user.identificationNumber ?? ''}',
                                              onChanged: (User? data) {
                                                conf.value = data?.id;
                                                _saveConfig(
                                                    configurationProvider,
                                                    conf);
                                              },
                                              validator: (User? item) {
                                                if (item == null) {
                                                  return "El asesor por defecto es requerido";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          )
                                        : const Text(
                                            'Nota: Debe crear al menos un asesor'))
                                    : const MyProgressIndicator();
                              },
                            );
                          }
                          return Container();
                        }).toList()
                      ],
                    ),
                    const SizedBox(height: 30),
                    /*         Container(
                      margin: const EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: CustomButtonPrimary(
                        onPressed: () => {}, //saveMultiple(),
                        title: 'Guardar',
                      ),
                    ), */
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<bool?> _saveConfig(
    ConfigurationProvider configurationProvider,
    Configuration config,
  ) async {
    {
      try {
        var saved = false;
        saved = await configurationProvider.saveConfig(config) ?? false;
        if (saved) {
          NotificationService.showSnackbarSuccess(
            '${config.helpText} actualizado',
          );
        }

        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar la configuración',
        );
      }
    }
  }
}
