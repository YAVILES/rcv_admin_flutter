import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/mark_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class MarksView extends StatefulWidget {
  const MarksView({Key? key}) : super(key: key);

  @override
  State<MarksView> createState() => _MarksViewState();
}

class _MarksViewState extends State<MarksView> {
  @override
  void initState() {
    super.initState();
    Provider.of<MarkProvider>(context, listen: false).getMarks();
  }

  @override
  Widget build(BuildContext context) {
    final markProvider = Provider.of<MarkProvider>(context);
    final loading = markProvider.loading;
    final marks = markProvider.marks;

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
                title: "Administración de Vehículos",
                subtitle: "Marcas",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () =>
                        NavigationService.navigateTo(context, markRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              (loading == true)
                  ? const MyProgressIndicator()
                  : GenericTable(
                      onSelectChanged: (data) => {},
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
                                      await Provider.of<MarkProvider>(context,
                                              listen: false)
                                          .deleteMarks(items
                                              .map((e) => e['id'].toString())
                                              .toList());
                                  if (deleted) {
                                    NotificationService.showSnackbarSuccess(
                                        'Mark eliminado con exito.');
                                  } else {
                                    NotificationService.showSnackbarSuccess(
                                        'No se pudo eliminar el Mark.');
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
                      data: marks,
                      columns: [
                        DTColumn(header: "Código", dataAttribute: 'code'),
                        DTColumn(
                            header: "Descripción",
                            dataAttribute: 'description'),
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
                        markProvider.search(value);
                      },
                      searchInitialValue: markProvider.searchValue,
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
              markDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}
