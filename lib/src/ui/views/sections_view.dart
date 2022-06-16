import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/generic_table_responsive.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/providers/section_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/section_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/utils_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';
import 'package:responsive_table/responsive_table.dart';

class SectionsView extends StatefulWidget {
  const SectionsView({Key? key}) : super(key: key);

  @override
  State<SectionsView> createState() => _SectionsViewState();
}

class _SectionsViewState extends State<SectionsView> {
  late List<DatatableHeader> _headers;
  String urlPath = SectionService.url;
  late Future<ResponseData?> Function(Map<String, dynamic>, String?) onSource;

  @override
  void initState() {
    super.initState();
    onSource =
        (params, url) => UtilsService.getListPaginated(params, url ?? urlPath);

    /// set headers
    _headers = [
      DatatableHeader(text: "Tipo", value: "type_display"),
      DatatableHeader(text: "Titulo", value: "title"),
      DatatableHeader(text: "Sub Titulo", value: "subtitle"),
      DatatableHeader(text: "Contenido", value: "content"),
      DatatableHeader(text: "Url", value: "url"),
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
    SectionProvider sectionProvider =
        Provider.of<SectionProvider>(context, listen: false);
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
                title: "Administración Web",
                subtitle: "Secciones",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () => NavigationService.navigateTo(
                        context, sectionRoute, null),
                    title: 'Nuevo',
                  ),
                  Consumer<SectionProvider>(builder: (context, obj, child) {
                    return Visibility(
                      visible: obj.selecteds.isNotEmpty,
                      child: CustomButtonPrimary(
                        color: Colors.red,
                        onPressed: () {
                          if (obj.loading == false) {
                            final dialog = AlertDialog(
                              title: const Text(
                                  '¿Estas seguro de rechazar los pagos seleccionados?'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Definitivamente deseas rechazar'),
                                  if (obj.loading == true)
                                    const MyProgressIndicator()
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Si, eliminar"),
                                  onPressed: () async {
                                    try {
                                      final rejected = await obj.deleteSections(
                                          obj.selecteds
                                              .map((e) => e["id"].toString())
                                              .toList());
                                      if (rejected) {
                                        NotificationService.showSnackbarSuccess(
                                            'Secciones eliminadas con exito.');
                                      } else {
                                        NotificationService.showSnackbarSuccess(
                                            'No se pudieron eliminar las secciones.');
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
                        title: 'Eliminar',
                      ),
                    );
                  })
                ],
              ),
              GenericTableResponsive(
                headers: _headers,
                onSource: (Map<String, dynamic> params, String? url) {
                  return onSource(params, url);
                },
                onSelect: (_selecteds) {
                  sectionProvider.selecteds = _selecteds;
                },
                showSelect: true,
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
              sectionDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        )
      ],
    );
  }
}
