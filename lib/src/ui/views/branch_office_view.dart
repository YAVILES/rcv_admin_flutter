import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/branch_office_model.dart';
import 'package:rcv_admin_flutter/src/providers/branch_office_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BranchOfficeView extends StatefulWidget {
  BranchOffice? branchOffice;
  String? uid;

  BranchOfficeView({
    Key? key,
    this.branchOffice,
    this.uid,
  }) : super(key: key);

  @override
  State<BranchOfficeView> createState() => _BranchOfficeViewState();
}

class _BranchOfficeViewState extends State<BranchOfficeView> {
  @override
  Widget build(BuildContext context) {
    if (widget.branchOffice != null) {
      return _BranchOfficeViewBody(branchOffice: widget.branchOffice!);
    } else {
      return FutureBuilder(
          future: Provider.of<BranchOfficeProvider>(context, listen: false)
              .getBranchOffice(widget.uid ?? ''),
          builder: (_, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? _BranchOfficeViewBody(branchOffice: snapshot.data)
                : const MyProgressIndicator();
          });
    }
  }
}

class _BranchOfficeViewBody extends StatefulWidget {
  BranchOffice branchOffice;

  _BranchOfficeViewBody({
    Key? key,
    required this.branchOffice,
  }) : super(key: key);

  @override
  __BranchOfficeViewBodyState createState() => __BranchOfficeViewBodyState();
}

class __BranchOfficeViewBodyState extends State<_BranchOfficeViewBody> {
  PlatformFile? photo;

  @override
  void initState() {
    Provider.of<BranchOfficeProvider>(context, listen: false)
        .formBranchOfficeKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BranchOfficeProvider branchOfficeProvider =
        Provider.of<BranchOfficeProvider>(context);
    BranchOffice _branchOffice =
        branchOfficeProvider.branchOffice = widget.branchOffice;
    final bool create = widget.branchOffice.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Susursal ${widget.branchOffice.code ?? ''}',
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                Form(
                  key: branchOfficeProvider.formBranchOfficeKey,
                  child: Wrap(
                    children: [
                      if (!create)
                        TextFormField(
                          readOnly: true,
                          initialValue: _branchOffice.number?.toString() ?? '',
                          onChanged: (value) =>
                              _branchOffice.number = int.parse(value),
                          onFieldSubmitted: (value) => _saveBranchOffice(
                              create, branchOfficeProvider, _branchOffice),
                          decoration: CustomInputs.buildInputDecoration(
                            hintText: 'Ingrese el  nro.',
                            labelText: 'Nro.',
                          ),
                        ),
                      TextFormField(
                        initialValue: _branchOffice.code ?? '',
                        onChanged: (value) => _branchOffice.code = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El código es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) => _saveBranchOffice(
                            create, branchOfficeProvider, _branchOffice),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el código.',
                          labelText: 'Código',
                        ),
                      ),
                      TextFormField(
                        initialValue: _branchOffice.description ?? '',
                        onChanged: (value) => _branchOffice.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) => _saveBranchOffice(
                            create, branchOfficeProvider, _branchOffice),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      TextFormField(
                        initialValue: _branchOffice.linkGoogleMaps ?? '',
                        onSaved: (value) =>
                            _branchOffice.linkGoogleMaps = value,
                        onChanged: (value) =>
                            _branchOffice.linkGoogleMaps = value,
                        onFieldSubmitted: (value) => _saveBranchOffice(
                            create, branchOfficeProvider, _branchOffice),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el link de google maps.',
                          labelText: 'Link de google maps',
                        ),
                      ),
                      CustomCheckBox(
                        title: 'Activo',
                        value: _branchOffice.isActive ?? true,
                        onChanged: (value) => _branchOffice.isActive = value,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () => _saveBranchOffice(
                              create, branchOfficeProvider, _branchOffice),
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

  Future<bool?> _saveBranchOffice(
    bool create,
    BranchOfficeProvider branchOfficeProvider,
    BranchOffice _branchOffice,
  ) async {
    try {
      var saved = false;
      if (create) {
        saved =
            await branchOfficeProvider.newBranchOffice(_branchOffice) ?? false;
        if (saved) {
          NotificationService.showSnackbarSuccess(
              '${_branchOffice.description} creado');
        }
      } else {
        saved = await branchOfficeProvider.editBranchOffice(
                _branchOffice.id!, _branchOffice) ??
            false;
        if (saved) {
          NotificationService.showSnackbarSuccess(
            '${_branchOffice.description} actualizado',
          );
        }
      }
      if (saved) {
        NavigationService.back(context);
      }
      return saved;
    } on ErrorAPI catch (e) {
      NotificationService.showSnackbarError(
        e.error?[0] ?? 'No se pudo guardar la sucursal',
      );
      return null;
    }
  }
}
