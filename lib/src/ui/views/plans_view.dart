import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rcv_admin_flutter/src/components/generic_table_responsive.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/services/utils_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/chips/custom_chip.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:responsive_table/responsive_table.dart';

class PlansView extends StatefulWidget {
  const PlansView({Key? key}) : super(key: key);

  @override
  State<PlansView> createState() => _PlansViewState();
}

class _PlansViewState extends State<PlansView> {
  late List<DatatableHeader> _headers;
  String urlPath = PlanService.url;
  late Future<ResponseData?> Function(Map<String, dynamic>, String?) onSource;

  @override
  void initState() {
    super.initState();
    onSource =
        (params, url) => UtilsService.getListPaginated(params, url ?? urlPath);

    /// set headers
    _headers = [
      DatatableHeader(text: "Código", value: "code"),
      DatatableHeader(text: "Descripción", value: "description"),
      DatatableHeader(
        text: "Usos",
        value: "uses_display",
        flex: 2,
        sourceBuilder: (value, row) => Wrap(
          children: [
            ...value.map(
              (e) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: CustomChip(
                  active: true,
                  withGesture: false,
                  title: e["description"],
                ),
              ),
            )
          ],
        ),
      ),
      DatatableHeader(
        text: "Fecha de Creación",
        value: "created",
        sourceBuilder: (value, row) {
          var formatterDate = DateFormat('yyyy-MM-dd');
          return Center(
            child: Text(
              formatterDate.format(
                DateTime.parse(value),
              ),
            ),
          );
        },
      ),
      DatatableHeader(
        text: "Fecha de actualización",
        value: "updated",
        sourceBuilder: (value, row) {
          var formatterDate = DateFormat('yyyy-MM-dd');
          return Center(
            child: Text(
              formatterDate.format(
                DateTime.parse(value),
              ),
            ),
          );
        },
      ),
      DatatableHeader(
        text: "Activo",
        value: "is_active",
        sourceBuilder: (value, row) => Center(
          child: Text(value == true ? 'Activo' : 'Inactivo'),
        ),
      ),
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
                subtitle: "Planes",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () =>
                        NavigationService.navigateTo(context, planRoute, null),
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
                onImport: (params) async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    // allowedExtensions: ['jpg'],
                    allowMultiple: false,
                  );

                  if (result != null) {
                    final resp =
                        await UtilsService.import(urlPath, result.files.first);
                    if (resp != null) {
                      setState(() {
                        onSource = (params, url) =>
                            UtilsService.getListPaginated(
                                params, url ?? urlPath);
                        NotificationService.showSnackbarSuccess(
                            'Carga masiva Exitosa');
                      });
                    } else {
                      NotificationService.showSnackbarError(
                          'No fue posible cargar la información');
                    }
                  } else {
                    // Planr canceled the picker
                  }
                },
                filenameExport: "planes",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsTable extends StatelessWidget {
  Map<String?, dynamic> item;
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
            NavigationService.navigateTo(
              context,
              planDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}
