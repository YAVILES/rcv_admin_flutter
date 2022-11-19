import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/incidence_model.dart';
import 'package:rcv_admin_flutter/src/models/policy_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/providers/incidence_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/policy_service.dart';
import 'package:rcv_admin_flutter/src/services/vehicle_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

import '../../models/vehicle_model.dart';

class IncidenceView extends StatefulWidget {
  Incidence? incidence;
  String? uid;

  IncidenceView({
    Key? key,
    this.incidence,
    this.uid,
  }) : super(key: key);

  @override
  State<IncidenceView> createState() => _IncidenceViewState();
}

class _IncidenceViewState extends State<IncidenceView> {
  @override
  Widget build(BuildContext context) {
    if (widget.incidence != null) {
      return _IncidenceViewBody(incidence: widget.incidence!);
    } else {
      return FutureBuilder(
        future: Provider.of<IncidenceProvider>(context, listen: false)
            .getIncidence(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _IncidenceViewBody(incidence: snapshot.data)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _IncidenceViewBody extends StatefulWidget {
  Incidence incidence;

  _IncidenceViewBody({
    Key? key,
    required this.incidence,
  }) : super(key: key);

  @override
  __IncidenceViewBodyState createState() => __IncidenceViewBodyState();
}

class __IncidenceViewBodyState extends State<_IncidenceViewBody> {
  PlatformFile? photo;
  Use? use;
  @override
  void initState() {
    Provider.of<IncidenceProvider>(context, listen: false).formIncidenceKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IncidenceProvider incidenceProvider =
        Provider.of<IncidenceProvider>(context, listen: false);
    Incidence _incidence = incidenceProvider.incidence = widget.incidence;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Incidencia',
            ),
            Column(
              children: [
                const SizedBox(height: 20),
                Form(
                  key: incidenceProvider.formIncidenceKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FutureBuilder(
                            future: VehicleService.getVehicles(
                              {'not_paginator': true},
                            ),
                            builder:
                                (_, AsyncSnapshot<List<Vehicle>?> snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.done
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: DropdownSearch<Vehicle>(
                                          items: snapshot.data!,
                                          dropdownSearchDecoration:
                                              const InputDecoration(
                                            hintText: "Seleccione el vehiculo",
                                            labelText: "Vehiculo",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          itemAsString: (Vehicle? vehicle) =>
                                              '${vehicle!.modelDisplay?.description} ${vehicle.licensePlate ?? ''}',
                                          onChanged: (Vehicle? data) {
                                            incidenceProvider.setVehicle(data);
                                            _incidence.vehicle = data!.id!;
                                          },
                                          validator: (Vehicle? item) {
                                            if (item == null) {
                                              return "El ehiculo es requerido";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  : const MyProgressIndicator();
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Consumer<IncidenceProvider>(
                              builder: (context, obj, child) {
                            return obj.vehicle == null
                                ? const SizedBox()
                                : FutureBuilder(
                                    future: PolicyService.getPolicies(
                                        obj.vehicle!.id!),
                                    builder: (_,
                                        AsyncSnapshot<List<Policy>?> snapshot) {
                                      return snapshot.connectionState ==
                                              ConnectionState.done
                                          ? Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: DropdownSearch<Policy>(
                                                  items: snapshot.data!,
                                                  dropdownSearchDecoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Seleccione la poliza",
                                                    labelText: "Poliza",
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            12, 12, 0, 0),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  itemAsString:
                                                      (Policy? item) =>
                                                          '${item?.number}',
                                                  onChanged: (Policy? item) {
                                                    incidenceProvider
                                                        .setPolicy(item);
                                                    _incidence.policy =
                                                        item!.id;
                                                  },
                                                  validator: (Policy? item) {
                                                    if (item == null) {
                                                      return "La poliza es requerido";
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
                      TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: _incidence.amount.toString(),
                        onChanged: (value) =>
                            _incidence.amount = double.parse(value),
                        decoration: const InputDecoration(
                          hintText: 'Ingrese el monto',
                          labelText: 'Monto',
                        ),
                      ),
                      TextFormField(
                        initialValue: _incidence.detail,
                        onChanged: (value) {
                          _incidence.detail = value;
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 10,
                        maxLines: 200,
                        decoration: const InputDecoration(
                          hintText: 'Ingrese el detalle',
                          labelText: 'Detalle',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _saveIncidence(incidenceProvider, _incidence),
                          title: 'Procesar',
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

  Future<bool?> _saveIncidence(
    IncidenceProvider incidenceProvider,
    Incidence _incidence,
  ) async {
    {
      try {
        var saved = false;
        saved = await incidenceProvider.newIncidence(_incidence) ?? false;
        if (saved) {
          NotificationService.showSnackbarSuccess('Poliza creada con exito');
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
