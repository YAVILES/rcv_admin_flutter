import 'dart:io';
import 'dart:typed_data';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/document_vehicle.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/bank_model.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/providers/bank_provider.dart';
import 'package:rcv_admin_flutter/src/services/bank_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/payment_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BankView extends StatefulWidget {
  Bank? bank;
  String? uid;

  BankView({
    Key? key,
    this.bank,
    this.uid,
  }) : super(key: key);

  @override
  State<BankView> createState() => _BankViewState();
}

class _BankViewState extends State<BankView> {
  @override
  Widget build(BuildContext context) {
    if (widget.bank != null) {
      return _BankViewBody(bank: widget.bank!);
    } else {
      return FutureBuilder(
        future: Provider.of<BankProvider>(context, listen: false)
            .getBank(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _BankViewBody(bank: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _BankViewBody extends StatefulWidget {
  Bank bank;
  bool withImage = false;

  _BankViewBody({
    Key? key,
    required this.bank,
  }) : super(key: key);

  @override
  __BankViewBodyState createState() => __BankViewBodyState();
}

class __BankViewBodyState extends State<_BankViewBody> {
  @override
  void initState() {
    Provider.of<BankProvider>(context, listen: false).formBankKey =
        GlobalKey<FormState>();
    Provider.of<BankProvider>(context, listen: false).bank = widget.bank;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BankProvider bankProvider = Provider.of<BankProvider>(context);
    Bank _bank = bankProvider.bank!;
    final bool create = widget.bank.id == null;
    GroupController controllerGroup = GroupController(
      initSelectedItem: _bank.methods,
      isMultipleSelection: true,
    );
    GroupController controllerGroupCoins = GroupController(
      initSelectedItem: _bank.coins,
      isMultipleSelection: true,
    );

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Pagos',
              subtitle: 'Banco ${widget.bank.code ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: bankProvider.formBankKey,
                  child: Wrap(
                    children: [
                      TextFormField(
                        readOnly: !create,
                        initialValue: _bank.code ?? '',
                        onChanged: (value) => _bank.code = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El código es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) => _saveBank(
                            create, bankProvider, _bank, widget.withImage),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la código.',
                          labelText: 'Código',
                        ),
                      ),
                      TextFormField(
                        initialValue: _bank.description ?? '',
                        onChanged: (value) => _bank.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) => _saveBank(
                            create, bankProvider, _bank, widget.withImage),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      TextFormField(
                        initialValue: _bank.email ?? '',
                        onChanged: (value) => _bank.email = value,
                        onFieldSubmitted: (value) => _saveBank(
                            create, bankProvider, _bank, widget.withImage),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el email.',
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        initialValue: _bank.accountNumber ?? '',
                        onChanged: (value) => _bank.accountNumber = value,
                        onFieldSubmitted: (value) => _saveBank(
                            create, bankProvider, _bank, widget.withImage),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el número de cuenta.',
                          labelText: 'Número de cuenta',
                        ),
                      ),
                      TextFormField(
                        initialValue: _bank.accountName ?? '',
                        onChanged: (value) => _bank.accountName = value,
                        onFieldSubmitted: (value) => _saveBank(
                            create, bankProvider, _bank, widget.withImage),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el nombre de la cuenta.',
                          labelText: 'Nombre de la cuenta',
                        ),
                      ),
                      FutureBuilder(
                        future: PaymentService.getMethods(),
                        builder:
                            (context, AsyncSnapshot<List<Option>?> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? SimpleGroupedCheckbox<int>(
                                  groupTitle: "Metodos de pago",
                                  controller: controllerGroup,
                                  itemsTitle: snapshot.data!
                                      .map((e) => e.description!)
                                      .toList(),
                                  values: snapshot.data!
                                      .map((e) => int.parse(e.value!))
                                      .toList(),
                                  isExpandableTitle: true,
                                  groupStyle: GroupStyle(
                                    activeColor: Colors.red,
                                    itemTitleStyle:
                                        const TextStyle(fontSize: 13),
                                  ),
                                  checkFirstElement: false,
                                  onItemSelected: (items) {
                                    _bank.methods = items;
                                  },
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      FutureBuilder(
                        future: PaymentService.getCoins(),
                        builder:
                            (context, AsyncSnapshot<List<Option>?> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? SimpleGroupedCheckbox<String>(
                                  groupTitle: "Monedas",
                                  controller: controllerGroupCoins,
                                  itemsTitle: snapshot.data!
                                      .map((e) => e.description!)
                                      .toList(),
                                  values: snapshot.data!
                                      .map((e) => e.value!)
                                      .toList(),
                                  isExpandableTitle: true,
                                  groupStyle: GroupStyle(
                                    activeColor: Colors.red,
                                    itemTitleStyle:
                                        const TextStyle(fontSize: 13),
                                  ),
                                  checkFirstElement: false,
                                  onItemSelected: (items) {
                                    _bank.coins = items;
                                  },
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      DocumentUploadDownload(
                        title: 'Imagen',
                        imageUrl: _bank.imageDisplay,
                        onDownload: _bank.id == null
                            ? null
                            : () async {
                                if (!kIsWeb) {
                                  if (Platform.isIOS ||
                                      Platform.isAndroid ||
                                      Platform.isMacOS) {
                                    bool status =
                                        await Permission.storage.isGranted;

                                    if (!status) {
                                      await Permission.storage.request();
                                    }
                                  }
                                }
                                Uint8List? data =
                                    await BankService.downloadImage(_bank.id!);
                                if (data != null) {
                                  MimeType type = MimeType.JPEG;
                                  String path =
                                      await FileSaver.instance.saveFile(
                                    "imagen_banco_${_bank.description.toString()}",
                                    data,
                                    "jpeg",
                                    mimeType: type,
                                  );
                                  NotificationService.showSnackbarSuccess(
                                      'Pago guardado en $path');
                                } else {
                                  NotificationService.showSnackbarError(
                                      'No se pudo descargar el excel');
                                }
                              },
                        onUpload: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            // allowedExtensions: ['jpg'],
                            allowMultiple: false,
                          );

                          if (result != null) {
                            setState(() {
                              _bank.image = result.files.first;
                              widget.withImage = true;
                            });
                          } else {
                            // User canceled the picker
                          }
                        },
                      ),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _bank.status == 1,
                          onChanged: (value) => _bank.status = value ? 1 : 0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () => _saveBank(
                              create, bankProvider, _bank, widget.withImage),
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

  Future<bool?> _saveBank(
    bool create,
    BankProvider bankProvider,
    Bank _bank,
    bool? withImage,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved =
              await bankProvider.newBank(_bank, withImage: withImage) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_bank.description} creado');
          }
        } else {
          saved = await bankProvider.editBank(_bank.id!, _bank,
                  withImage: withImage) ??
              false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_bank.description} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el bank',
        );
      }
    }
  }
}
