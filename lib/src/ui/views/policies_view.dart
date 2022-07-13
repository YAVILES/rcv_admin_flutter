import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rcv_admin_flutter/src/components/generic_table_responsive.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/policy_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/utils_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/modals/payment_modal.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:responsive_table/responsive_table.dart';

class PoliciesView extends StatefulWidget {
  const PoliciesView({Key? key}) : super(key: key);

  @override
  State<PoliciesView> createState() => _PoliciesViewState();
}

class _PoliciesViewState extends State<PoliciesView> {
  late List<DatatableHeader> _headers;
  String urlPath = PolicyService.url;
  late Future<ResponseData?> Function(Map<String, dynamic>, String?) onSource;

  @override
  void initState() {
    super.initState();
    onSource =
        (params, url) => UtilsService.getListPaginated(params, url ?? urlPath);

    /// set headers
    _headers = [
      DatatableHeader(text: "Nro.", value: "number"),
      DatatableHeader(text: "Tipo", value: "type_display"),
      DatatableHeader(
        text: "Tomador",
        value: "taker_display",
        sourceBuilder: (value, row) => Center(
          child: Text('${value["full_name"]}'),
        ),
      ),
      DatatableHeader(
        text: "Asegurado",
        value: "vehicle_display",
        sourceBuilder: (value, row) => Center(
          child: Text('${value["owner_name"]} ${value["owner_last_name"]}'),
        ),
      ),
      DatatableHeader(
        text: "Asesor",
        value: "adviser_display",
        sourceBuilder: (value, row) => Center(
          child: Text('${value["full_name"]}'),
        ),
      ),
      DatatableHeader(
        text: "Vehículo",
        value: "vehicle_display",
        sourceBuilder: (value, row) => Center(
          child: Text(
              '${value["model_display"]["mark_display"]["description"]} ${value["model_display"]["description"]} ${value["color"]}'),
        ),
      ),
      DatatableHeader(
        text: "Plan",
        value: "plan_display",
        sourceBuilder: (value, row) => Center(
          child: Text('${value["description"]}'),
        ),
      ),
      DatatableHeader(
        text: "Creado por",
        value: "created_by_display",
        sourceBuilder: (value, row) {
          return value == null
              ? const SizedBox()
              : Center(
                  child: Text('${value["full_name"]}'),
                );
        },
      ),
      DatatableHeader(
        text: "Fec. Vancimiento",
        value: "due_date",
        sourceBuilder: (value, row) => Center(
          child: Text(
            value == null
                ? "N/A"
                : DateFormat('yyyy-MM-dd').format(
                    DateTime.parse(value),
                  ),
          ),
        ),
      ),
      DatatableHeader(text: "Estatus", value: "status_display"),
      DatatableHeader(
        text: "Acciones",
        value: "id",
        sourceBuilder: (value, row) {
          return _ActionsTable(item: row);
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
              HeaderView(
                title: "Administración de Sistema",
                subtitle: "Polizas",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () => NavigationService.navigateTo(
                        context, policyRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              GenericTableResponsive(
                headers: _headers,
                onSource: (Map<String, dynamic> params, String? url) {
                  return onSource(params, url);
                },
                onExport: (params) {
                  return UtilsService.export(urlPath);
                },
                filenameExport: "polizas",
                // ignore: prefer_const_literals_to_create_immutables
                params: {
                  "query": """{id, number, type_display, taker_display 
                {full_name}, vehicle_display {model_display, color, owner_name, owner_last_name}, adviser_display {full_name}, 
                plan_display {description}, created_by_display {full_name}, 
                due_date, status, status_display}"""
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsTable extends StatefulWidget {
  Map<String?, dynamic> item;

  _ActionsTable({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<_ActionsTable> createState() => _ActionsTableState();
}

class _ActionsTableState extends State<_ActionsTable> {
  bool downloadinPdf = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            NavigationService.navigateTo(
              context,
              policyDetailRoute,
              {'id': widget.item['id'].toString()},
            );
          },
        ),
        if (widget.item["status"] == PolicyService.outstanding)
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.payment_sharp),
            onPressed: () {
              showMaterialModalBottomSheet(
                expand: true,
                context: context,
                builder: (_) {
                  return PaymentModal(
                    policy: Policy.fromMap(widget.item),
                  );
                },
              );
            },
          ),
        if (widget.item["status"] == PolicyService.passed)
          downloadinPdf == true
              ? const MyProgressIndicator()
              : IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: const Icon(Icons.picture_as_pdf_sharp),
                  onPressed: () async {
                    setState(() {
                      downloadinPdf = true;
                    });
                    Uint8List? data =
                        await PolicyService.downloadPdf(widget.item["id"]);
                    if (data != null) {
                      MimeType type = MimeType.PDF;
                      String path = await FileSaver.instance.saveFile(
                        "poliza_${widget.item["number"]}",
                        data,
                        "pdf",
                        mimeType: type,
                      );
                      NotificationService.showSnackbarSuccess(
                          'Poliza guardado en $path');
                    } else {
                      NotificationService.showSnackbarError(
                          'No se pudo descargar la poliza');
                    }
                    setState(() {
                      downloadinPdf = false;
                    });
                  },
                ),
      ],
    );
  }
}
