import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/coverage_model.dart';
import 'package:rcv_admin_flutter/src/providers/coverage_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/chips/custom_chip.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class CoverageView extends StatefulWidget {
  Coverage? coverage;
  String? uid;

  CoverageView({
    Key? key,
    this.coverage,
    this.uid,
  }) : super(key: key);

  @override
  State<CoverageView> createState() => _CoverageViewState();
}

class _CoverageViewState extends State<CoverageView> {
  @override
  Widget build(BuildContext context) {
    if (widget.coverage != null) {
      return _CoverageViewBody(coverage: widget.coverage!);
    } else {
      return FutureBuilder(
        future: Provider.of<CoverageProvider>(context, listen: false)
            .getCoverage(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _CoverageViewBody(coverage: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _CoverageViewBody extends StatefulWidget {
  Coverage coverage;

  _CoverageViewBody({
    Key? key,
    required this.coverage,
  }) : super(key: key);

  @override
  __CoverageViewBodyState createState() => __CoverageViewBodyState();
}

class __CoverageViewBodyState extends State<_CoverageViewBody> {
  @override
  void initState() {
    Provider.of<CoverageProvider>(context, listen: false).formCoverageKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CoverageProvider coverageProvider = Provider.of<CoverageProvider>(context);
    Coverage _coverage = coverageProvider.coverage = widget.coverage;
    final bool create = widget.coverage.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Cobertura ${widget.coverage.code ?? ''}',
            ),
            Column(
              children: [
                Form(
                  key: coverageProvider.formCoverageKey,
                  child: Wrap(
                    children: [
                      TextFormField(
                        initialValue: _coverage.code ?? '',
                        onChanged: (value) => _coverage.code = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El código es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveCoverage(create, coverageProvider, _coverage),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el código.',
                          labelText: 'Código',
                        ),
                      ),
                      TextFormField(
                        initialValue: _coverage.description ?? '',
                        onChanged: (value) => _coverage.description = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveCoverage(create, coverageProvider, _coverage),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la descripción.',
                          labelText: 'Descripción',
                        ),
                      ),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Por Defecto',
                          value: _coverage.coverageDefault ?? true,
                          onChanged: (value) =>
                              _coverage.coverageDefault = value,
                        ),
                      ),
                      FutureBuilder(
                        future: PlanService.getPlans({
                          'not_paginator': true,
                          'query': '{id, description}'
                        }),
                        builder: (_, AsyncSnapshot snapshot) {
                          return snapshot.connectionState ==
                                  ConnectionState.done
                              ? Row(
                                  children: [
                                    const Text('plans'),
                                    const SizedBox(width: 20),
                                    Wrap(
                                      children: [
                                        ...snapshot.data!.map(
                                          (plan) => Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: CustomChip(
                                              active: coverageProvider
                                                  .coverage!.plans!
                                                  .contains(plan.id!),
                                              onTap: (active) {
                                                if (active) {
                                                  coverageProvider.coverage!
                                                              .plans !=
                                                          null
                                                      ? coverageProvider
                                                          .coverage!.plans!
                                                          .add(plan.id!)
                                                      : coverageProvider
                                                          .coverage!
                                                          .plans = [plan.id!];
                                                } else {
                                                  if (coverageProvider
                                                          .coverage!.plans !=
                                                      null) {
                                                    coverageProvider
                                                        .coverage!.plans!
                                                        .remove(plan.id!);
                                                  }
                                                }
                                              },
                                              title: plan.description!,
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
                      const SizedBox(width: 50),
                      SizedBox(
                        width: 155,
                        child: CustomCheckBox(
                          title: 'Activo',
                          value: _coverage.isActive ?? true,
                          onChanged: (value) => _coverage.isActive = value,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () => _saveCoverage(
                              create, coverageProvider, _coverage),
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

  Future<bool?> _saveCoverage(
    bool create,
    CoverageProvider coverageProvider,
    Coverage _coverage,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await coverageProvider.newCoverage(_coverage) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_coverage.description} creado');
          }
        } else {
          saved =
              await coverageProvider.editCoverage(_coverage.id!, _coverage) ??
                  false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_coverage.description} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.backTo(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el coverage',
        );
      }
    }
  }
}
