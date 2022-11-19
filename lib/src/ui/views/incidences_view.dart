import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rcv_admin_flutter/src/components/generic_table_responsive.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/incidence_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/incidence_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/utils_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/modals/payment_modal.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:responsive_table/responsive_table.dart';

class IncidencesView extends StatefulWidget {
  const IncidencesView({Key? key}) : super(key: key);

  @override
  State<IncidencesView> createState() => _IncidencesViewState();
}

class _IncidencesViewState extends State<IncidencesView> {
  late List<DatatableHeader> _headers;
  String urlPath = IncidenceService.url;
  late Future<ResponseData?> Function(Map<String, dynamic>, String?) onSource;

  @override
  void initState() {
    super.initState();
    onSource =
        (params, url) => UtilsService.getListPaginated(params, url ?? urlPath);

    /// set headers
    _headers = [
      DatatableHeader(
        text: "Vehículo",
        value: "vehicle_display",
        sourceBuilder: (value, row) => Center(
          child: Text(
              '${value["model_display"]["mark_display"]["description"]} ${value["model_display"]["description"]} ${value["color"]}'),
        ),
      ),
      DatatableHeader(
        text: "Poliza",
        value: "policy_display",
        sourceBuilder: (value, row) => Center(
          child: Text('${value["number"]}'),
        ),
      ),
      DatatableHeader(text: "Monto", value: "amount"),
      DatatableHeader(text: "Detalle", value: "detail"),
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
                        context, incidenceRoute, null),
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
                  "query":
                      """{id, vehicle_display {model_display, color, owner_name, owner_last_name}, 
                      policy_display {number}, amount, detail}"""
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*   IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            NavigationService.navigateTo(
              context,
              incidenceDetailRoute,
              {'id': widget.item['id'].toString()},
            );
          },
        ), */
      ],
    );
  }
}
