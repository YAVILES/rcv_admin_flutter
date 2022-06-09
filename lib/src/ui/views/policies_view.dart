import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/providers/policy_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/policy_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/modals/payment_modal.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PoliciesView extends StatefulWidget {
  const PoliciesView({Key? key}) : super(key: key);

  @override
  State<PoliciesView> createState() => _PoliciesViewState();
}

class _PoliciesViewState extends State<PoliciesView> {
  @override
  void initState() {
    super.initState();
    Provider.of<PolicyProvider>(context, listen: false).getPolicies();
  }

  @override
  Widget build(BuildContext context) {
    final policyProvider = Provider.of<PolicyProvider>(context);
    final loading = policyProvider.loading;
    final policies = policyProvider.policies;

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
                subtitle: "Pólizas",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () => NavigationService.navigateTo(
                        context, policyRoute, null),
                    title: 'Nueva',
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
                                      await Provider.of<PolicyProvider>(context,
                                              listen: false)
                                          .deletePolicies(items
                                              .map((e) => e['id'].toString())
                                              .toList());
                                  if (deleted) {
                                    NotificationService.showSnackbarSuccess(
                                        'Policy eliminado con exito.');
                                  } else {
                                    NotificationService.showSnackbarSuccess(
                                        'No se pudo eliminar el Policy.');
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
                      data: policies,
                      columns: [
                        DTColumn(
                          header: "Nro.",
                          dataAttribute: 'number',
                        ),
                        DTColumn(
                          header: "Tipo",
                          dataAttribute: 'type_display',
                        ),
                        DTColumn(
                          header: "Tomador",
                          dataAttribute: 'taker',
                          widget: (item) {
                            return Text(
                                '${item["taker_display"]["name"]} ${item["taker_display"]["last_name"]}');
                          },
                        ),
                        DTColumn(
                          header: "Asegurado",
                          dataAttribute: 'updated',
                          widget: (item) {
                            return Text(
                                '${item["vehicle_display"]["owner_name"]} ${item["vehicle_display"]["owner_last_name"]}');
                          },
                        ),
                        DTColumn(
                          header: "Asesor",
                          dataAttribute: 'adviser',
                          widget: (item) {
                            return Text(
                                '${item["adviser_display"]["name"]} ${item["adviser_display"]["last_name"]}');
                          },
                        ),
                        DTColumn(
                          header: "Vehículo",
                          dataAttribute: 'vehicle',
                          widget: (item) {
                            return Text(
                                '${item["vehicle_display"]["model_display"]["mark_display"]["description"]} ${item["vehicle_display"]["model_display"]["description"]} ${item["vehicle_display"]["color"]}');
                          },
                        ),
                        DTColumn(
                          header: "Plan",
                          dataAttribute: 'plan',
                          widget: (item) {
                            return Text(
                                '${item["plan_display"]["description"]}');
                          },
                        ),
                        DTColumn(
                          header: "Creada por",
                          dataAttribute: 'created_by',
                          widget: (item) {
                            return Text(
                                '${item["created_by_display"]?["name"] ?? ''} ${item["created_by_display"]?["last_name"] ?? ''}');
                          },
                        ),
                        DTColumn(
                          header: "Fecha de vencimiento",
                          dataAttribute: 'due_date',
                          type: TypeColumn.dateTime,
                        ),
                        DTColumn(
                          header: "Estatus",
                          dataAttribute: 'status_display',
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
                        policyProvider.search(value);
                      },
                      searchInitialValue: policyProvider.searchValue,
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
              policyDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
        if (item["status"] == PolicyService.outstanding ||
            item["status"] == PolicyService.pendingApproval)
          IconButton(
            icon: const Icon(Icons.payment_outlined),
            onPressed: () {
              showMaterialModalBottomSheet(
                expand: true,
                context: context,
                builder: (_) => PaymentModal(
                  policy: Policy.fromMap(item),
                ),
              );
            },
          ),
      ],
    );
  }
}
