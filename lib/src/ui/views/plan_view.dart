import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/providers/plan_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/use_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/chips/custom_chip.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class PlanView extends StatefulWidget {
  Plan? plan;
  String? uid;

  PlanView({
    Key? key,
    this.plan,
    this.uid,
  }) : super(key: key);

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  @override
  Widget build(BuildContext context) {
    if (widget.plan != null) {
      return _PlanViewBody(plan: widget.plan!);
    } else {
      return FutureBuilder(
        future: Provider.of<PlanProvider>(context, listen: false)
            .getPlan(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _PlanViewBody(plan: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _PlanViewBody extends StatefulWidget {
  Plan plan;

  _PlanViewBody({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  __PlanViewBodyState createState() => __PlanViewBodyState();
}

class __PlanViewBodyState extends State<_PlanViewBody> {
  @override
  void initState() {
    Provider.of<PlanProvider>(context, listen: false).formPlanKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlanProvider planProvider = Provider.of<PlanProvider>(context);
    Plan _plan = planProvider.plan = widget.plan;
    final bool create = widget.plan.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Plan ${widget.plan.code ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: planProvider.formPlanKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: _plan.code ?? '',
                        onChanged: (value) => _plan.code = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El código es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _savePlan(create, planProvider, _plan),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el código.',
                          labelText: 'Código',
                        ),
                      ),
                      TextFormField(
                        initialValue: _plan.description ?? '',
                        onChanged: (value) => _plan.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _savePlan(create, planProvider, _plan),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: UseService.getUses(
                            {'is_active': true, 'not_paginator': true}),
                        builder: (_, AsyncSnapshot<List<Use>?> snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? Row(
                                  children: [
                                    const Text('Usos'),
                                    const SizedBox(width: 20),
                                    if (snapshot.data != null)
                                      Wrap(
                                        children: [
                                          ...snapshot.data!.map(
                                            (uso) => Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: CustomChip(
                                                active: planProvider.plan!.uses!
                                                    .contains(uso.id!),
                                                onTap: (active) {
                                                  if (active) {
                                                    planProvider.plan!.uses !=
                                                            null
                                                        ? planProvider
                                                            .plan!.uses!
                                                            .add(uso.id!)
                                                        : planProvider.plan!
                                                            .uses = [uso.id!];
                                                  } else {
                                                    if (planProvider
                                                            .plan!.uses !=
                                                        null) {
                                                      planProvider.plan!.uses!
                                                          .remove(uso.id!);
                                                    }
                                                  }
                                                },
                                                title: uso.description!,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _plan.isActive ?? true,
                          onChanged: (value) => _plan.isActive = value,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _savePlan(create, planProvider, _plan),
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

  Future<bool?> _savePlan(
    bool create,
    PlanProvider planProvider,
    Plan _plan,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await planProvider.newPlan(_plan) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_plan.description} creado');
          }
        } else {
          saved = await planProvider.editPlan(_plan.id!, _plan) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_plan.description} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.backTo(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el plan',
        );
      }
    }
  }
}
