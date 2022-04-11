import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/mark_model.dart';
import 'package:rcv_admin_flutter/src/providers/mark_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class MarkView extends StatefulWidget {
  Mark? mark;
  String? uid;

  MarkView({
    Key? key,
    this.mark,
    this.uid,
  }) : super(key: key);

  @override
  State<MarkView> createState() => _MarkViewState();
}

class _MarkViewState extends State<MarkView> {
  @override
  Widget build(BuildContext context) {
    if (widget.mark != null) {
      return _MarkViewBody(mark: widget.mark!);
    } else {
      return FutureBuilder(
        future: Provider.of<MarkProvider>(context, listen: false)
            .getMark(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _MarkViewBody(mark: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _MarkViewBody extends StatefulWidget {
  Mark mark;

  _MarkViewBody({
    Key? key,
    required this.mark,
  }) : super(key: key);

  @override
  __MarkViewBodyState createState() => __MarkViewBodyState();
}

class __MarkViewBodyState extends State<_MarkViewBody> {
  @override
  void initState() {
    Provider.of<MarkProvider>(context, listen: false).formMarkKey =
        GlobalKey<FormState>();
    Provider.of<MarkProvider>(context, listen: false).mark = widget.mark;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MarkProvider markProvider = Provider.of<MarkProvider>(context);
    Mark _mark = markProvider.mark!;
    final bool create = widget.mark.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Vehículos',
              subtitle: 'Marca ${widget.mark.code ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: markProvider.formMarkKey,
                  child: Wrap(
                    children: [
                      TextFormField(
                        initialValue: _mark.description ?? '',
                        onChanged: (value) => _mark.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveMark(create, markProvider, _mark),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _mark.isActive ?? true,
                          onChanged: (value) => _mark.isActive = value,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _saveMark(create, markProvider, _mark),
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

  Future<bool?> _saveMark(
    bool create,
    MarkProvider markProvider,
    Mark _mark,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await markProvider.newMark(_mark) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_mark.description} creado');
          }
        } else {
          saved = await markProvider.editMark(_mark.id!, _mark) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_mark.description} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el mark',
        );
      }
    }
  }
}
