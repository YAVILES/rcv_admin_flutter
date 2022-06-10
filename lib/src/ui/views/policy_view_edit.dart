import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/providers/coverage_provider.dart';
import 'package:rcv_admin_flutter/src/providers/plan_provider.dart';
import 'package:rcv_admin_flutter/src/providers/policy_provider.dart';
import 'package:rcv_admin_flutter/src/providers/vehicle_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PolicyViewEdit extends StatefulWidget {
  Policy? policy;
  String? uid;

  PolicyViewEdit({
    Key? key,
    this.policy,
    this.uid,
  }) : super(key: key);

  @override
  State<PolicyViewEdit> createState() => _PolicyViewEditState();
}

class _PolicyViewEditState extends State<PolicyViewEdit> {
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
    Policy _policy = policyProvider.policy = widget.policy;

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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _policy.number.toString(),
                              enabled: true,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Número',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue: '${_policy.actionDisplay}',
                              enabled: false,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Acción',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue:
                                  '${_policy.takerDisplay?.name} ${_policy.takerDisplay?.lastName} ${_policy.takerDisplay?.identificationNumber ?? ''}',
                              enabled: false,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Tomador',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue:
                                  '${_policy.vehicleDisplay?.ownerName} ${_policy.vehicleDisplay?.ownerLastName} ${_policy.vehicleDisplay?.ownerIdentityCard ?? ''}}',
                              enabled: false,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Asegurado',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue:
                                  '${_policy.adviserDisplay?.name} ${_policy.adviserDisplay?.lastName} ${_policy.adviserDisplay?.identificationNumber ?? ''}',
                              enabled: false,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Asesor',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue:
                                  '${_policy.createdByDisplay?.name ?? ''} ${_policy.createdByDisplay?.lastName ?? ''}',
                              enabled: false,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Creada por',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _policy.vehicleDisplay?.modelDisplay
                                  ?.markDisplay?.description,
                              enabled: true,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Vehicle',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue:
                                  '${_policy.planDisplay?.description}',
                              enabled: false,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Plan',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _policy.typeDisplay,
                              enabled: true,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Tipo',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              initialValue: '${_policy.statusDisplay}',
                              enabled: false,
                              decoration: CustomInputs.buildInputDecoration(
                                labelText: 'Estatus',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          GenericTable(
                            paginated: false,
                            withSearchEngine: false,
                            data:
                                _policy.items?.map((e) => e.toMap()).toList() ??
                                    [],
                            columns: [
                              DTColumn(
                                header: "Cobertura",
                                dataAttribute: 'description',
                                widget: (item) => Text(
                                  '${item["coverage_display"]["description"]}',
                                ),
                                onSort: false,
                              ),
                              DTColumn(
                                header: "Monto \nAsegurado",
                                dataAttribute: 'id',
                                widget: (item) =>
                                    Text('${item["insured_amount_display"]}'),
                                onSort: false,
                              ),
                              DTColumn(
                                header: "Costo",
                                dataAttribute: 'premium',
                                widget: (item) =>
                                    Text('${item["cost_display"]}'),
                                onSort: false,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Monto asegurado total: ${_policy.totalInsuredAmountDisplay ?? ''}',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Costo total: ${_policy.totalAmountDisplay ?? ''}',
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      /*         Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () => _savePolicy(policyProvider, _policy),
                          title: 'Guardar',
                        ),
                      ), */
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
    PolicyProvider policyProvider,
    Policy _policy,
  ) async {
    {
      try {
        var saved = false;
        saved = await policyProvider.editPolicy(_policy.id!, _policy) ?? false;
        if (saved) {
          NotificationService.showSnackbarSuccess(
            'Poliza actualizada con exito',
          );
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
