import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as x;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/generic_table_responsive.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/payment_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/providers/payment_provider.dart';

import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/payment_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/modals/payment_modal.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';
import 'package:responsive_table/responsive_table.dart';

class PaymentsView extends StatefulWidget {
  const PaymentsView({Key? key}) : super(key: key);

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  late List<DatatableHeader> _headers;
  List<Map<String, dynamic>> selecteds = [];
  late PaymentProvider paymentProvider;
  @override
  void initState() {
    super.initState();
    paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

    /// set headers
    _headers = [
      DatatableHeader(text: "Nro", value: "number"),
      DatatableHeader(text: "Referencia", value: "reference"),
      DatatableHeader(
        text: "Moneda",
        value: "coins_display",
        sourceBuilder: (value, row) {
          return Center(child: Text(row["coin_display"]["description"]));
        },
      ),
      DatatableHeader(text: "Monto", value: "amount"),
      DatatableHeader(text: "Factor de Cambio", value: "change_factor_display"),
      DatatableHeader(text: "Estatus", value: "status_display"),
      DatatableHeader(
        text: "Acciones",
        value: "id",
        sourceBuilder: (value, row) {
          return _ActionsTable(item: Map<String, dynamic>.from(row));
        },
      )
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        child: CenteredView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Consumer<PaymentProvider>(
                builder: (context, obj, child) {
                  return HeaderView(
                    title: "Administración de Pagos",
                    subtitle: "Pagos",
                    actions: [
                      if (obj.selecteds.isNotEmpty &&
                          obj.selecteds
                              .where(
                                  (e) => e["status"] != PaymentService.pending)
                              .toList()
                              .isEmpty) ...[
                        CustomButtonPrimary(
                          color: Colors.red,
                          onPressed: () {
                            if (obj.loading == false) {
                              final dialog = AlertDialog(
                                title: const Text(
                                    '¿Estas seguro de rechazar los pagos seleccionados?'),
                                content: Consumer<PaymentProvider>(
                                    builder: (context, objP, child) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          'Definitivamente deseas rechazar'),
                                      if (objP.loading == true)
                                        const MyProgressIndicator()
                                    ],
                                  );
                                }),
                                actions: [
                                  TextButton(
                                    child: const Text("No"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Si, rechazar"),
                                    onPressed: () async {
                                      try {
                                        final rejected = await paymentProvider
                                            .rejectedPayments(obj.selecteds
                                                .map((e) => e["id"].toString())
                                                .toList());
                                        if (rejected) {
                                          NotificationService
                                              .showSnackbarSuccess(
                                                  'Pagos rechazados con exito.');
                                        } else {
                                          NotificationService.showSnackbarSuccess(
                                              'No se pudieron rechazar los pagos.');
                                        }
                                      } on ErrorAPI catch (e) {
                                        NotificationService.showSnackbarError(
                                            e.detail.toString());
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                              showDialog(
                                  context: context, builder: (_) => dialog);
                            }
                          },
                          title: 'Rechazar',
                        ),
                        CustomButtonPrimary(
                          onPressed: () {
                            final dialog = AlertDialog(
                              title: const Text(
                                  '¿Estas seguro de aprobar los pagos seleccionados?'),
                              content: Consumer<PaymentProvider>(
                                  builder: (context, objP, child) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        'Definitivamente deseas aprobar'),
                                    if (objP.loading == true)
                                      const MyProgressIndicator()
                                  ],
                                );
                              }),
                              actions: [
                                TextButton(
                                  child: const Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Si, aprobar"),
                                  onPressed: () async {
                                    if (obj.loading == false) {
                                      try {
                                        final approved = await paymentProvider
                                            .approvePayments(obj.selecteds
                                                .map((e) => e["id"].toString())
                                                .toList());
                                        if (approved) {
                                          NotificationService
                                              .showSnackbarSuccess(
                                                  'Pagos aprobados con exito.');
                                        } else {
                                          NotificationService.showSnackbarSuccess(
                                              'No se pudieron aprobar los pagos.');
                                        }
                                      } on ErrorAPI catch (e) {
                                        NotificationService.showSnackbarError(
                                            e.detail.toString());
                                      }
                                      Navigator.of(context).pop();
                                    }
                                  },
                                )
                              ],
                            );
                            showDialog(
                                context: context, builder: (_) => dialog);
                          },
                          title: 'Aprobar',
                        ),
                      ]
                    ],
                  );
                },
              ),
              GenericTableResponsive(
                headers: _headers,
                onSource: (Map<String, dynamic> params, String? url) {
                  return PaymentService.getPaymentsPaginated(params, url);
                },
                onExport: (params) {
                  return PaymentService.export();
                },
                filenameExport: "pagos",
                params: {
                  "query":
                      """{id, number, bank_display, coin_display, method_display, 
                  amount, amount_display, policy_display {id, number}, status, 
                  status_display, change_factor, change_factor_display,
                  reference, archive_display}"""
                },
                showSelect: true,
                onSelect: (_selecteds) {
                  paymentProvider.selecteds = _selecteds;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsTable extends StatelessWidget {
  Map<String, dynamic> item;
  _ActionsTable({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            showMaterialModalBottomSheet(
              expand: true,
              context: context,
              builder: (_) {
                return PaymentModal(
                  policy: Policy.fromMap(item["policy_display"]),
                  payment: Payment.fromJson(item),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
