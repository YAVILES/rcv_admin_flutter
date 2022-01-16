import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/coverage_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class CoveragesView extends StatefulWidget {
  const CoveragesView({Key? key}) : super(key: key);

  @override
  State<CoveragesView> createState() => _CoveragesViewState();
}

class _CoveragesViewState extends State<CoveragesView> {
  @override
  void initState() {
    super.initState();
    Provider.of<CoverageProvider>(context, listen: false).getCoverages();
  }

  @override
  Widget build(BuildContext context) {
    final coverageProvider = Provider.of<CoverageProvider>(context);
    final loading = coverageProvider.loading;
    final coverages = coverageProvider.coverages;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: CenteredView(
          child: Column(
            children: [
              HeaderView(
                title: "Administración de Sistema",
                subtitle: "Coberturas",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () => NavigationService.navigateTo(
                        context, coverageRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              (loading == true)
                  ? const MyProgressIndicator()
                  : GenericTable(
                      onSelectChanged: (data) => print(data.item.toString()),
                      onDeleteSelectedItems: (items) {
                        final dialog = AlertDialog(
                          title: const Text(
                              '¿Estas seguro de eliminar los items seleccionados?'),
                          content:
                              const Text('Definitivamente deseas eliminar'),
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
                                  final deleted =
                                      await Provider.of<CoverageProvider>(
                                              context,
                                              listen: false)
                                          .deleteCoverages(items
                                              .map((e) => e['id'].toString())
                                              .toList());
                                  if (deleted) {
                                    NotificationService.showSnackbarSuccess(
                                        'Coverage eliminado con exito.');
                                  } else {
                                    NotificationService.showSnackbarSuccess(
                                        'No se pudo eliminar el coverage.');
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
                        showDialog(context: context, builder: (_) => dialog);
                      },
                      data: coverages,
                      columns: [
                        DTColumn(header: "Código", dataAttribute: 'code'),
                        DTColumn(
                            header: "Descripción",
                            dataAttribute: 'description'),
                        DTColumn(
                          header: "Por defecto",
                          dataAttribute: 'default',
                          widget: (item) => item['default'] == true
                              ? const Text('SI')
                              : const Text('NO'),
                        ),
                        DTColumn(
                          header: "Estatus",
                          dataAttribute: 'is_active',
                          widget: (item) => item['is_active'] == true
                              ? const Text('Activo')
                              : const Text('Inactivo'),
                        ),
                        DTColumn(
                          header: "Acciones",
                          dataAttribute: 'id',
                          widget: (item) {
                            return _ActionsTable(item: item);
                          },
                          onSort: false,
                        ),
                      ],
                      onSearch: (value) {
                        coverageProvider.search(value);
                      },
                      searchInitialValue: coverageProvider.searchValue,
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
            NavigationService.navigateTo(
              context,
              coverageDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}
