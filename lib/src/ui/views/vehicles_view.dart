import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/vehicle_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class VehiclesView extends StatefulWidget {
  const VehiclesView({Key? key}) : super(key: key);

  @override
  State<VehiclesView> createState() => _VehiclesViewState();
}

class _VehiclesViewState extends State<VehiclesView> {
  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final loading = vehicleProvider.loading;
    final vehicles = vehicleProvider.vehicles;

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
                subtitle: "Vehículos",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () => NavigationService.navigateTo(
                        context, vehicleRoute, null),
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
                                      await Provider.of<VehicleProvider>(
                                              context,
                                              listen: false)
                                          .deleteVehicles(items
                                              .map((e) => e['id'].toString())
                                              .toList());
                                  if (deleted) {
                                    NotificationService.showSnackbarSuccess(
                                        'Vehicle eliminado con exito.');
                                  } else {
                                    NotificationService.showSnackbarSuccess(
                                        'No se pudo eliminar el Vehicle.');
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
                      data: vehicles,
                      columns: [
                        DTColumn(
                            header: "Placa", dataAttribute: 'license_plate'),
                        DTColumn(
                          header: "Modelo",
                          dataAttribute: 'model',
                          widget: (item) =>
                              Text(item['model_display']['description']),
                        ),
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
                        vehicleProvider.search(value);
                      },
                      searchInitialValue: vehicleProvider.searchValue,
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
              vehicleDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}
