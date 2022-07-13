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
                          if (conf.key == 'CHANGE_FACTOR' ||
                              conf.key == 'PHONES' ||
                              conf.key == "FAX" ||
                              conf.key == "DESCRIPTION" ||
                              conf.key == "LOCATION_PRINCIPAL" ||
                              conf.key == "LOCATION_PRINCIPAL_GOOGLE_MAPS" ||
                              conf.key == "EMAIL") {
                            return Row(
                              children: [
                                // Text(conf.helpText!),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: conf.value.toString(),
                                    onChanged: (value) => conf.value = value,
                                    validator: (value) {
                                      if ((value == null || value.isEmpty) &&
                                          conf.key == "CHANGE_FACTOR") {
                                        return '${conf.helpText} es obligatorio';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) => {
                                      _saveConfig(configurationProvider, conf)
                                    },
                                    // _saveConfiguration(conf),
                                    decoration:
                                        CustomInputs.buildInputDecoration(
                                      hintText: '${conf.helpText}',
                                      labelText: conf.helpText!,
                                      constraints:
                                          const BoxConstraints(maxWidth: 140),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            );
                          } else if (conf.key == 'ADVISER_DEFAULT_ID') {
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
                                              items: snapshot.data!,
                                              selectedItem: conf.value != null
                                                  ? snapshot.data
                                                      ?.where((d) =>
                                                          d.id == conf.value)
                                                      .first
                                                  : null,
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
                                        : Row(
                                            children: const [
                                              Text(
                                                  'Nota: Debe crear al menos un asesor'),
                                            ],
                                          ))
                                    : const MyProgressIndicator();
                              },
                            );
                          }
                          /*      
                          else if (conf.key == 'LOGO') {
                            return Row(
                              children: [
                                const Text("Logo"),
                                const SizedBox(
                                  width: 30,
                                ),
                                Stack(
                                  children: [
                                    conf.value != null
                                        ? Image.network(conf.value, width: 200)
                                        : obj.logo != null
                                            ? Image.memory(
                                                Uint8List.fromList(
                                                    obj.logo!.bytes!),
                                                width: 200)
                                            : Image.asset(
                                                'assets/images/16410.png',
                                                width: 200,
                                              ),
                                    Positioned(
                                      bottom: 4,
                                      right: 4,
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.all(
                                              color: Colors.white, width: 5),
                                        ),
                                        child: FloatingActionButton(
                                          backgroundColor: Colors.indigo,
                                          elevation: 0,
                                          onPressed: () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                              // allowedExtensions: ['jpg'],
                                              allowMultiple: false,
                                            );

                                            if (result != null) {
                                              obj.logo = result.files.first;
                                            } else {
                                              // User canceled the picker
                                            }
                                          },
                                          child: const Icon(Icons.upload),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } */

                          else {
                            return Container();
                          }
                        }).toList()
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: CustomButtonPrimary(
                        onPressed: () => configurationProvider
                            .saveMultiPle(obj.configurations), //saveMultiple(),
                        title: 'Guardar',
                      ),
                    ),
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
