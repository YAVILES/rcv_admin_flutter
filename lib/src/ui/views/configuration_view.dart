import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/configuration_model.dart';
import 'package:rcv_admin_flutter/src/providers/configuration_provider.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
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
                              width: 300,
                              child: Row(
                                children: [
                                  Text(conf.helpText!),
                                  const SizedBox(width: 15),
                                  TextFormField(
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
                                      hintText: 'Ingrese el factor de cambio.',
                                      labelText: conf.helpText!,
                                      constraints:
                                          const BoxConstraints(maxWidth: 150),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }).toList()
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: CustomButtonPrimary(
                        onPressed: () => configurationProvider
                            .formConfigurationKey.currentState!
                            .save(),
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