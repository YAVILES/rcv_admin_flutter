import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/providers/premium_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/modals/premium_modal.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class PremiumsView extends StatefulWidget {
  const PremiumsView({Key? key}) : super(key: key);

  @override
  State<PremiumsView> createState() => _PremiumsViewState();
}

class _PremiumsViewState extends State<PremiumsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlansUses plansAndUses = PlansUses();
    PremiumProvider premiumProvider = Provider.of<PremiumProvider>(context);

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
                subtitle: "Gestión de primas",
              ),
              StreamBuilder(
                stream: PlanService.getPlansAndUses(paramsPlans: {
                  'not_paginator': true,
                  'is_active': true,
                  'query':
                      '{id, description, uses, uses_display {code, description}, coverage {id, description, premium}}'
                }, paramsUses: {
                  'is_active': true,
                  'not_paginator': true,
                  'query': '{id, description, premiums}'
                }),
                builder: (context, AsyncSnapshot<PlansUses?> snapshot) {
                  if (snapshot.hasData) {
                    plansAndUses = snapshot.data!;
                  }
                  return snapshot.connectionState == ConnectionState.done
                      ? GenericTable(
                          withSearchEngine: false,
                          dataRowHeight: 110,
                          data: plansAndUses.plans != null
                              ? plansAndUses.plans!
                                  .map((e) => e.toMap())
                                  .toList()
                              : [],
                          columns: [
                            DTColumn(
                                onSort: false,
                                header: "Plan",
                                dataAttribute: 'description'),
                            ...?plansAndUses.uses
                                ?.map(
                                  (use) => DTColumn(
                                    header: use.description,
                                    dataAttribute: 'id',
                                    widget: (plan) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TotalCoverage(
                                            plan: Plan.fromMap(plan),
                                            use: use,
                                            premiums: use.premiums
                                                    ?.where((Premium premium) =>
                                                        premium.plan ==
                                                        plan['id'])
                                                    .toList() ??
                                                [],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ],
                          // searchInitialValue: premiumProvider.searchValue,
                        )
                      : const MyProgressIndicator();
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
            NavigationService.navigateTo(
              context,
              premiumDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}

class TotalCoverage extends StatefulWidget {
  List<Premium> premiums;
  Plan plan;
  Use use;

  TotalCoverage({
    Key? key,
    required this.premiums,
    required this.plan,
    required this.use,
  }) : super(key: key);

  @override
  State<TotalCoverage> createState() => _TotalCoverageState();
}

class _TotalCoverageState extends State<TotalCoverage> {
  @override
  Widget build(BuildContext context) {
    double totalCost = 0;
    double totalInsuredAmount = 0;
    if (widget.plan.uses != null && widget.plan.uses!.contains(widget.use.id)) {
      for (Premium element in widget.premiums) {
        totalCost += element.cost ?? 0;
        totalInsuredAmount += element.insuredAmount ?? 0;
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${totalCost.toString()} \$',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '${totalInsuredAmount.toString()} \$',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          CustomButtonPrimary(
            title: 'Modificar',
            tooltipMessage:
                "\n Plan: ${widget.plan.description} \n Uso: ${widget.use.description} \n",
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => PremiumModal(
                  plan: widget.plan,
                  use: widget.use,
                ),
              );
            },
          ),
          const SizedBox(height: 5),
          (widget.premiums.length != widget.plan.coverage?.length)
              ? const Icon(
                  Icons.warning,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'N/A',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
