import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/providers/use_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class UseView extends StatefulWidget {
  Use? use;
  String? uid;

  UseView({
    Key? key,
    this.use,
    this.uid,
  }) : super(key: key);

  @override
  State<UseView> createState() => _UseViewState();
}

class _UseViewState extends State<UseView> {
  @override
  Widget build(BuildContext context) {
    if (widget.use != null) {
      return _UseViewBody(use: widget.use!);
    } else {
      return FutureBuilder(
        future: Provider.of<UseProvider>(context, listen: false)
            .getUse(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _UseViewBody(use: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _UseViewBody extends StatefulWidget {
  Use use;

  _UseViewBody({
    Key? key,
    required this.use,
  }) : super(key: key);

  @override
  __UseViewBodyState createState() => __UseViewBodyState();
}

class __UseViewBodyState extends State<_UseViewBody> {
  @override
  void initState() {
    Provider.of<UseProvider>(context, listen: false).formUseKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UseProvider useProvider = Provider.of<UseProvider>(context);
    Use _use = useProvider.use = widget.use;
    final bool create = widget.use.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Uso ${widget.use.code ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: useProvider.formUseKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: _use.code ?? '',
                        onChanged: (value) => _use.code = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El código es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveUse(create, useProvider, _use),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el código.',
                          labelText: 'Código',
                        ),
                      ),
                      TextFormField(
                        initialValue: _use.description ?? '',
                        onChanged: (value) => _use.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveUse(create, useProvider, _use),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      const SizedBox(width: 50),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _use.isActive ?? true,
                          onChanged: (value) => _use.isActive = value,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () => _saveUse(create, useProvider, _use),
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

  Future<bool?> _saveUse(
    bool create,
    UseProvider useProvider,
    Use _use,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await useProvider.newUse(_use) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_use.description} creado');
          }
        } else {
          saved = await useProvider.editUse(_use.id!, _use) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_use.description} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el use',
        );
      }
    }
  }
}
