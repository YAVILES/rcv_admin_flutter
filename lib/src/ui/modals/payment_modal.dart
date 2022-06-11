import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/document_vehicle.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/bank_model.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/payment_model.dart';

import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/providers/payment_provider.dart';
import 'package:rcv_admin_flutter/src/providers/policy_provider.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/payment_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';

class PaymentModal extends StatefulWidget {
  final Policy policy;
  Payment? payment;

  PaymentModal({
    Key? key,
    required this.policy,
    this.payment,
  }) : super(key: key);

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  late PaymentProvider paymentProvider;
  late PolicyProvider policyProvider;
  @override
  void initState() {
    super.initState();
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    policyProvider = Provider.of<PolicyProvider>(context, listen: false);
    paymentProvider.formPaymentKey = GlobalKey<FormState>();
    if (widget.payment != null) {
      paymentProvider.payment = widget.payment!;
      paymentProvider.coin = widget.payment!.coinDisplay;
      paymentProvider.method = Option.fromMap({
        "value": widget.payment!.method,
        "description": widget.payment!.methodDisplay,
      });
      paymentProvider.amount = widget.payment!.amount ?? 0;
      paymentProvider.bank = widget.payment!.bankDisplay;
      paymentProvider.reference = widget.payment!.reference ?? "";
      paymentProvider.archiveImage = widget.payment!.archiveDisplay;
    }
    paymentProvider.policy = widget.policy;
    paymentProvider.getMethods();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: buildBoxDecoration(context),
          child: Form(
            key: paymentProvider.formPaymentKey,
            child: Column(
              children: [
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Pago de Póliza ${widget.policy.number}',
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.payment != null,
                          child: TextFormField(
                            enabled: false,
                            initialValue: widget.payment?.number.toString(),
                            onFieldSubmitted: (value) {},
                            decoration: CustomInputs.buildInputDecoration(
                              labelText: 'Número',
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: PaymentService.getCoins(),
                          builder: (_, AsyncSnapshot<List<Option>?> snapshot) {
                            return snapshot.connectionState ==
                                    ConnectionState.done
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Consumer<PaymentProvider>(
                                        builder: (context, obj, child) {
                                      return DropdownSearch<Option>(
                                        enabled: widget.payment == null,
                                        selectedItem: obj.coin,
                                        items: snapshot.data!,
                                        dropdownSearchDecoration:
                                            const InputDecoration(
                                          hintText: "Seleccione la moneda",
                                          labelText: "Moneda",
                                          contentPadding:
                                              EdgeInsets.fromLTRB(12, 12, 0, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                        itemAsString: (Option? coin) =>
                                            '${coin?.description}',
                                        onChanged: (Option? data) {
                                          if (data != null) {
                                            paymentProvider
                                                .getBanksForCoin(data);
                                          }
                                        },
                                        validator: (Option? item) {
                                          if (item == null) {
                                            return "Debe seleccionar la moneda obligatoriamente";
                                          } else {
                                            return null;
                                          }
                                        },
                                      );
                                    }),
                                  )
                                : const MyProgressIndicator();
                          },
                        ),
                        Consumer<PaymentProvider>(
                          builder: (context, obj, child) {
                            return obj.loadingBanks
                                ? const MyProgressIndicator()
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: DropdownSearch<Bank>(
                                          enabled: obj.payment == null,
                                          selectedItem: obj.bank,
                                          items: obj.banks,
                                          dropdownSearchDecoration:
                                              const InputDecoration(
                                            hintText: "Seleccione el banco",
                                            labelText: "Banco",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          itemAsString: (Bank? bank) =>
                                              '${bank?.description}',
                                          onChanged: (Bank? data) {
                                            paymentProvider.bank = data;
                                            paymentProvider
                                                .setAvailableMethods();
                                          },
                                          validator: (Bank? item) {
                                            if (item == null) {
                                              return "Debe seleccionar el banco obligatoriamente";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      Visibility(
                                        visible: obj.bank != null,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: DropdownSearch<Option>(
                                                enabled: obj.payment == null,
                                                selectedItem: obj.method,
                                                items: obj.availableMethods,
                                                dropdownSearchDecoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      "Seleccione el metodo",
                                                  labelText: "Metodo de Pago",
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                itemAsString: (Option?
                                                        method) =>
                                                    '${method?.description}',
                                                onChanged: (Option? data) {
                                                  paymentProvider.method = data;
                                                },
                                                validator: (Option? item) {
                                                  if (item == null) {
                                                    return "Debe seleccionar el metodo";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            ),
                                            TextFormField(
                                              enabled: obj.payment == null,
                                              keyboardType:
                                                  TextInputType.number,
                                              initialValue:
                                                  widget.payment == null
                                                      ? paymentProvider.amount
                                                          .toString()
                                                      : paymentProvider.payment
                                                          ?.amountDisplay,
                                              onChanged: (value) =>
                                                  paymentProvider.amount =
                                                      double.parse(value),
                                              onFieldSubmitted: (value) {},
                                              decoration: CustomInputs
                                                  .buildInputDecoration(
                                                hintText: 'Ingrese el monto.',
                                                labelText: 'Monto',
                                              ),
                                              validator: (value) {
                                                if (value == null) {
                                                  return "El monto es obligatorio";
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            if (obj.method != null &&
                                                obj.method?.value !=
                                                    PaymentService.cash
                                                        .toString())
                                              TextFormField(
                                                enabled: obj.payment == null,
                                                initialValue:
                                                    paymentProvider.reference,
                                                onChanged: (value) =>
                                                    paymentProvider.reference =
                                                        value,
                                                onFieldSubmitted: (value) {},
                                                decoration: CustomInputs
                                                    .buildInputDecoration(
                                                  hintText:
                                                      'Ingrese la referencia.',
                                                  labelText: 'Referencia',
                                                ),
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "La referencia es obligatoria";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            Visibility(
                                              visible: widget.payment != null,
                                              child: TextFormField(
                                                enabled: false,
                                                initialValue: widget
                                                    .payment?.statusDisplay,
                                                onFieldSubmitted: (value) {},
                                                decoration: CustomInputs
                                                    .buildInputDecoration(
                                                  labelText: 'Estatus',
                                                ),
                                              ),
                                            ),
                                            DocumentUploadDownload(
                                              title: 'Documento',
                                              imageUrl:
                                                  obj.payment?.archiveDisplay ??
                                                      obj.archiveImage,
                                              onDownload: obj.payment == null
                                                  ? null
                                                  : () async {
                                                      await paymentProvider
                                                          .downloadArchive();
                                                    },
                                              onUpload: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  // allowedExtensions: ['jpg'],
                                                  allowMultiple: false,
                                                );

                                                if (result != null) {
                                                  setState(() {
                                                    paymentProvider.archive =
                                                        result.files.first;
                                                    paymentProvider
                                                            .archiveImage =
                                                        result.files.first
                                                            .toString();
                                                  });
                                                } else {
                                                  // User canceled the picker
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: widget.payment == null,
                                child: CustomButtonPrimary(
                                  onPressed: () async {
                                    try {
                                      bool? saved = false;
                                      saved =
                                          await paymentProvider.savePayment();
                                      if (saved == true) {
                                        NotificationService.showSnackbarSuccess(
                                            'Guardado con exito');
                                        policyProvider.getPolicies();
                                        Navigator.of(context).pop();
                                      } else {
                                        NotificationService.showSnackbarError(
                                          'No fue posible guardar guardar',
                                        );
                                      }
                                      // PaymentProvider.notify();
                                    } catch (e) {
                                      NotificationService.showSnackbarError(
                                        'No fue posible guardar guardar',
                                      );
                                    }
                                  },
                                  title: 'Pagar',
                                ),
                              ),
                              Visibility(
                                visible: widget.payment != null &&
                                    widget.payment!.status ==
                                        PaymentService.pending,
                                child: CustomButtonPrimary(
                                  color: Colors.red,
                                  onPressed: () async {
                                    try {
                                      bool? rejected = false;
                                      rejected = await paymentProvider
                                          .rejectedPayment();
                                      if (rejected == true) {
                                        NotificationService.showSnackbarSuccess(
                                            'Rechazado con exito');
                                        Navigator.of(context).pop();
                                      } else {
                                        NotificationService.showSnackbarError(
                                          'No fue posible rechazar el pago',
                                        );
                                      }
                                    } catch (e) {
                                      NotificationService.showSnackbarError(
                                        'No fue posible rechazar el pago',
                                      );
                                    }
                                  },
                                  title: 'Rechazar',
                                ),
                              ),
                              Visibility(
                                visible: widget.payment != null &&
                                    widget.payment!.status ==
                                        PaymentService.pending,
                                child: CustomButtonPrimary(
                                  onPressed: () async {
                                    try {
                                      bool? approve = false;
                                      approve = await paymentProvider
                                          .approvePayment();
                                      if (approve == true) {
                                        NotificationService.showSnackbarSuccess(
                                            'Aprobado con exito');
                                        Navigator.of(context).pop();
                                      } else {
                                        NotificationService.showSnackbarError(
                                          'No fue posible aprobar el pago',
                                        );
                                      }
                                    } catch (e) {
                                      NotificationService.showSnackbarError(
                                        'No fue posible aprobar el pago',
                                      );
                                    }
                                  },
                                  title: 'Aprobar',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Colors.black26),
      ],
    );
  }
}
