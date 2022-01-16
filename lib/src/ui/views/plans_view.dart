import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/plan_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/chips/custom_chip.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class PlansView extends StatefulWidget {
  const PlansView({Key? key}) : super(key: key);

  @override
  State<PlansView> createState() => _PlansViewState();
}

class _PlansViewState extends State<PlansView> {
  @override
  void initState() {
    super.initState();
    Provider.of<PlanProvider>(context, listen: false).getPlans();
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
    final loading = planProvider.loading;
    final plans = planProvider.plans;

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
                subtitle: "Planes",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () =>
                        NavigationService.navigateTo(context, planRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              (loading == true)
                  ? const MyProgressIndicator()
                  : GenericTable(
                      data: plans,
                      columns: [
                        DTColumn(header: "Código", dataAttribute: 'code'),
                        DTColumn(
                          header: "Descripción",
                          dataAttribute: 'description',
                        ),
                        /*          DTColumn(
                          header: "Usos",
                          dataAttribute: 'uses',
                          widget: (item) {
                            return item['uses_display'] == null ||
                                    item['uses_display'].isEmpty
                                ? const Text('N/A')
                                : Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 400),
                                    child: Wrap(
                                      spacing: 5,
                                      children: [
                                        ...item['uses_display'].map(
                                          (w) => CustomChip(
                                            withGesture: false,
                                            title: w['description'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ), */
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
                        planProvider.search(value);
                      },
                      searchInitialValue: planProvider.searchValue,
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
              planDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}
