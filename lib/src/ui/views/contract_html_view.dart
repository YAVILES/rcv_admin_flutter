import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/configuration_model.dart';
import 'package:rcv_admin_flutter/src/services/configuration_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class ContractHTMLView extends StatefulWidget {
  const ContractHTMLView({Key? key}) : super(key: key);

  @override
  State<ContractHTMLView> createState() => _ContractHTMLViewState();
}

class _ContractHTMLViewState extends State<ContractHTMLView> {
  late GlobalKey<FormState> formKey;
  Configuration? config;
  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración Web',
              subtitle: 'Contrato HTML',
            ),
            Form(
              key: formKey,
              child: FutureBuilder(
                  future: ConfigurationService.get('HTML_CONTRACT'),
                  builder: (_, AsyncSnapshot<Configuration?> snapshot) {
                    if (snapshot.hasData) {
                      config = snapshot.data!;
                    }
                    return snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done
                        ? Column(
                            children: [
                              TextFormField(
                                initialValue: snapshot.data?.value,
                                onChanged: (value) {
                                  config!.value = value;
                                },
                                keyboardType: TextInputType.multiline,
                                minLines: 10,
                                maxLines: 200,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                alignment: Alignment.center,
                                child: CustomButtonPrimary(
                                  title: 'Guardar',
                                  onPressed: () async {
                                    final data =
                                        await ConfigurationService.updateConfig(
                                      config!.id!,
                                      config!,
                                    );
                                    if (data != null) {
                                      NotificationService.showSnackbarSuccess(
                                        'Contrato actualizado con exito',
                                      );
                                    } else {
                                      NotificationService.showSnackbarError(
                                        'No fue posible actualizar el contrato',
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : const MyProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
