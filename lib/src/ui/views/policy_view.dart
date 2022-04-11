import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/client_model.dart';
import 'package:rcv_admin_flutter/src/models/plan_model.dart';

import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/providers/client_provider.dart';
import 'package:rcv_admin_flutter/src/providers/coverage_provider.dart';
import 'package:rcv_admin_flutter/src/providers/plan_provider.dart';
import 'package:rcv_admin_flutter/src/providers/policy_provider.dart';
import 'package:rcv_admin_flutter/src/providers/vehicle_provider.dart';
import 'package:rcv_admin_flutter/src/services/client_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/services/use_service.dart';
import 'package:rcv_admin_flutter/src/services/vehicle_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/client_view.dart';
import 'package:rcv_admin_flutter/src/ui/views/vehicle_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

import '../../models/vehicle_model.dart';

class PolicyView extends StatefulWidget {
  Policy? policy;
  String? uid;

  PolicyView({
    Key? key,
    this.policy,
    this.uid,
  }) : super(key: key);

  @override
  State<PolicyView> createState() => _PolicyViewState();
}

class _PolicyViewState extends State<PolicyView> {
  @override
  Widget build(BuildContext context) {
    if (widget.policy != null) {
      return _PolicyViewBody(policy: widget.policy!);
    } else {
      return FutureBuilder(
        future: Provider.of<PolicyProvider>(context, listen: false)
            .getPolicy(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _PolicyViewBody(policy: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _PolicyViewBody extends StatefulWidget {
  Policy policy;

  _PolicyViewBody({
    Key? key,
    required this.policy,
  }) : super(key: key);

  @override
  __PolicyViewBodyState createState() => __PolicyViewBodyState();
}

class __PolicyViewBodyState extends State<_PolicyViewBody> {
  PlatformFile? photo;
  Use? use;
  @override
  void initState() {
    Provider.of<PolicyProvider>(context, listen: false).formPolicyKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PolicyProvider policyProvider =
        Provider.of<PolicyProvider>(context, listen: false);
    VehicleProvider vehicleProvider =
        Provider.of<VehicleProvider>(context, listen: false);
    PlanProvider planProvider =
        Provider.of<PlanProvider>(context, listen: false);
    CoverageProvider coverageProvider =
        Provider.of<CoverageProvider>(context, listen: false);

    Policy _policy = policyProvider.policy = widget.policy;
    Client? taker;

    final bool create = widget.policy.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Poliza ${widget.policy.number ?? ''}',
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                Form(
                  key: policyProvider.formPolicyKey,
                  child: Column(
                    children: [
                      if (!create)
                        Row(
                          children: [
                            TextFormField(
                              readOnly: true,
                              initialValue: _policy.number.toString(),
                              decoration: CustomInputs.buildInputDecoration(
                                hintText: 'Nro. de la poliza',
                                labelText: 'Nro.',
                                constraints:
                                    const BoxConstraints(maxWidth: 150),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Consumer<ClientProvider>(
                              builder: (context, obj, child) {
                            return FutureBuilder(
                              future: ClientService.getClients({
                                'not_paginator': true,
                                'is_staff': false,
                                // if (create) 'is_active': true,
                              }),
                              builder:
                                  (_, AsyncSnapshot<List<Client>?> snapshot) {
                                return snapshot.connectionState ==
                                        ConnectionState.done
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: DropdownSearch<Client>(
                                            mode: Mode.MENU,
                                            items: snapshot.data,
                                            showSearchBox: true,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
                                              hintText: "Seleccione el tomador",
                                              labelText: "Tomador / Cliente",
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 12, 0, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                            itemAsString: (Client? client) =>
                                                '${client!.fullName!} ${client.identificationNumber ?? ''}',
                                            onChanged: (Client? data) {
                                              policyProvider.setTaker(data);
                                              vehicleProvider.notifyUse(use);
                                              _policy.taker = data!.id;
                                            },
                                            validator: (Client? item) {
                                              if (item == null) {
                                                return "El tomador es requerido";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    : const MyProgressIndicator();
                              },
                            );
                          }),
                          Consumer<PolicyProvider>(
                              builder: (context, obj, child) {
                            return Visibility(
                              visible: obj.taker != null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () => showMaterialModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    builder: (_) => ClientView(
                                      client: obj.taker!,
                                      modal: true,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () => showMaterialModalBottomSheet(
                                expand: true,
                                context: context,
                                builder: (_) => ClientView(
                                  modal: true,
                                ),
                              ),
                              icon: const Icon(
                                Icons.add,
                              ),
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          FutureBuilder(
                            future: UseService.getUses({
                              'not_paginator': true,
                              'query': '{id, description}',
                              if (create) 'is_active': true,
                            }),
                            builder: (_, AsyncSnapshot<List<Use>?> snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.done
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: DropdownSearch<Use>(
                                          mode: Mode.MENU,
                                          items: snapshot.data,
                                          showSearchBox: true,
                                          dropdownSearchDecoration:
                                              const InputDecoration(
                                            hintText: "Seleccione el uso",
                                            labelText: "Uso",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          itemAsString: (Use? use) =>
                                              '${use!.description}',
                                          onChanged: (Use? data) {
                                            use = data;
                                            vehicleProvider.notifyUse(data);
                                            planProvider.notifyUse(data);
                                          },
                                          validator: (Use? item) {
                                            if (item == null) {
                                              return "El uso es requerido";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  : const MyProgressIndicator();
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Consumer<VehicleProvider>(
                              builder: (context, obj, child) {
                            use = obj.use;
                            return FutureBuilder(
                              future: VehicleService.getVehicles({
                                'not_paginator': true,
                                'taker_id': _policy.taker,
                                'use_id': obj.use?.id,
                              }),
                              builder:
                                  (_, AsyncSnapshot<List<Vehicle>> snapshot) {
                                return snapshot.connectionState ==
                                        ConnectionState.done
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: DropdownSearch<Vehicle>(
                                            mode: Mode.MENU,
                                            items: snapshot.data,
                                            showSearchBox: true,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
                                              hintText:
                                                  "Seleccione el vehículo",
                                              labelText: "Vehículo",
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 12, 0, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                            itemAsString: (Vehicle? item) =>
                                                '${item?.modelDisplay!.markDisplay!.description} ${item?.modelDisplay!.description} ',
                                            onChanged: (Vehicle? item) {
                                              policyProvider.setVehicle(item);
                                            },
                                            validator: (Vehicle? item) {
                                              if (item == null) {
                                                return "El vehículo es requerido";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    : const MyProgressIndicator();
                              },
                            );
                          }),
                          Consumer<PolicyProvider>(
                              builder: (context, obj, child) {
                            _policy.vehicle = obj.vehicle?.id;
                            return Visibility(
                              visible: obj.vehicle != null,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: () => showMaterialModalBottomSheet(
                                    expand: true,
                                    context: context,
                                    builder: (_) => VehicleView(
                                      vehicle: obj.vehicle!,
                                      modal: true,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () => showMaterialModalBottomSheet(
                                expand: true,
                                context: context,
                                builder: (_) => VehicleView(
                                  modal: true,
                                ),
                              ),
                              icon: const Icon(
                                Icons.add,
                              ),
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Consumer<PlanProvider>(
                              builder: (context, obj, child) {
                            return FutureBuilder(
                              future: PlanService.getPlans({
                                'not_paginator': true,
                                'use': obj.use?.id,
                                if (create) 'is_active': true,
                              }),
                              builder: (_, AsyncSnapshot<List<Plan>> snapshot) {
                                return snapshot.connectionState ==
                                        ConnectionState.done
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: DropdownSearch<Plan>(
                                            mode: Mode.MENU,
                                            items: snapshot.data,
                                            showSearchBox: true,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
                                              hintText: "Seleccione el plan",
                                              labelText: "Plan",
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 12, 0, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                            itemAsString: (Plan? item) =>
                                                '${item?.description}',
                                            onChanged: (Plan? item) {
                                              _policy.planDisplay = item;
                                              _policy.plan = item?.id;
                                              coverageProvider.notifyCoverage(
                                                  item, use);
                                            },
                                            validator: (Plan? item) {
                                              if (item == null) {
                                                return "El plan es requerido";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    : const MyProgressIndicator();
                              },
                            );
                          }),
                        ],
                      ),
                      if (create)
                        Consumer<CoverageProvider>(
                            builder: (context, obj, child) {
                          _policy.coverage =
                              obj.plan?.coverage!.map((e) => e.id!).toList();
                          return GenericTable(
                            title: "Coberturas: ",
                            withSearchEngine: false,
                            data: obj.plan?.coverage
                                    ?.map((e) => e.toMap())
                                    .toList() ??
                                [],
                            columns: [
                              DTColumn(
                                header: "Cobertura",
                                dataAttribute: 'description',
                                onSort: false,
                              ),
                              DTColumn(
                                header: "Monto \nAsegurado",
                                dataAttribute: 'id',
                                widget: (item) => Text(
                                    '${item["premium"]?["insured_amount"]}'),
                                onSort: false,
                              ),
                              DTColumn(
                                header: "Costo",
                                dataAttribute: 'premium',
                                widget: (item) =>
                                    Text('${item["premium"]?["cost"]}'),
                                onSort: false,
                              ),
                            ],
                          );
                        }),
                      if (!create) ...[
                        const SizedBox(
                          height: 40,
                        ),
                        GenericTable(
                          title: "Coberturas: ",
                          withSearchEngine: false,
                          data: policyProvider.policy!.items!
                              .map((e) => e.toMap())
                              .toList(),
                          columns: [
                            DTColumn(
                              header: "Nro.",
                              dataAttribute: 'number',
                              onSort: false,
                            ),
                            DTColumn(
                              header: "Monto",
                              dataAttribute: 'insured_amount',
                              onSort: false,
                            ),
                            DTColumn(
                              header: "costo",
                              dataAttribute: 'cost',
                              onSort: false,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Total asegurado: '),
                            Text(_policy.totalInsuredAmount.toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Total costo: '),
                            Text(_policy.totalAmount.toString()),
                          ],
                        ),
                      ],
                      if (create)
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          child: CustomButtonPrimary(
                            onPressed: () =>
                                _savePolicy(create, policyProvider, _policy),
                            title: 'Guardar',
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _savePolicy(
    bool create,
    PolicyProvider policyProvider,
    Policy _policy,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await policyProvider.newPolicy(_policy) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess('Poliza ceada con exito');
          }
        } else {
          saved =
              await policyProvider.editPolicy(_policy.id!, _policy) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              'Actualización exitosa',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar la poliza',
        );
      }
    }
  }
}
