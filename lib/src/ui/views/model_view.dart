import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/model_model.dart';
import 'package:rcv_admin_flutter/src/providers/model_provider.dart';
import 'package:rcv_admin_flutter/src/services/mark_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

import '../../models/mark_model.dart';

class ModelView extends StatefulWidget {
  Model? model;
  String? uid;

  ModelView({
    Key? key,
    this.model,
    this.uid,
  }) : super(key: key);

  @override
  State<ModelView> createState() => _ModelViewState();
}

class _ModelViewState extends State<ModelView> {
  @override
  Widget build(BuildContext context) {
    if (widget.model != null) {
      return _ModelViewBody(model: widget.model!);
    } else {
      return FutureBuilder(
        future: Provider.of<ModelProvider>(context, listen: false)
            .getModel(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _ModelViewBody(model: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _ModelViewBody extends StatefulWidget {
  Model model;

  _ModelViewBody({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  __ModelViewBodyState createState() => __ModelViewBodyState();
}

class __ModelViewBodyState extends State<_ModelViewBody> {
  @override
  void initState() {
    Provider.of<ModelProvider>(context, listen: false).formModelKey =
        GlobalKey<FormState>();
    Provider.of<ModelProvider>(context, listen: false).model = widget.model;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ModelProvider modelProvider = Provider.of<ModelProvider>(context);
    Model _model = modelProvider.model!;
    final bool create = widget.model.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Vehículos',
              subtitle: 'Modelo ${widget.model.code ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: modelProvider.formModelKey,
                  child: Wrap(
                    children: [
                      FutureBuilder(
                          future: MarkService.getMarks({
                            'query': '{id, description}',
                            'not_paginator': true
                          }),
                          builder:
                              (context, AsyncSnapshot<List<Mark>?> snapshot) {
                            return snapshot.connectionState !=
                                    ConnectionState.done
                                ? const MyProgressIndicator()
                                : DropdownButtonFormField(
                                    hint: const Text("Modelo"),
                                    // Initial Value
                                    value: _model.mark,

                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),

                                    // Array list of items
                                    items: snapshot.data!.map((Mark item) {
                                      return DropdownMenuItem(
                                        value: item.id,
                                        child: Text(item.description!),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? value) =>
                                        _model.mark = value,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'La marca es obligatoria';
                                      }
                                      return null;
                                    },
                                  );
                          }),
                      TextFormField(
                        initialValue: _model.description ?? '',
                        onChanged: (value) => _model.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveModel(create, modelProvider, _model),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _model.isActive ?? true,
                          onChanged: (value) => _model.isActive = value,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _saveModel(create, modelProvider, _model),
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

  Future<bool?> _saveModel(
    bool create,
    ModelProvider modelProvider,
    Model _model,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await modelProvider.newModel(_model) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_model.description} creado');
          }
        } else {
          saved = await modelProvider.editModel(_model.id!, _model) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_model.description} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el model',
        );
      }
    }
  }
}
