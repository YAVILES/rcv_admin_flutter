import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/plan_model.dart';
import 'package:rcv_admin_flutter/src/models/premium_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/plan_service.dart';
import 'package:rcv_admin_flutter/src/services/premium_service.dart';
import 'package:rcv_admin_flutter/src/services/use_service.dart';
import 'package:rcv_admin_flutter/src/services/utils_service.dart';
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
  String urlPath = PremiumService.url;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlansUses plansAndUses = PlansUses();

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
                actions: [
                  CustomButtonPrimary(
                    title: "Exportar Primas",
                    onPressed: () async {
                      if (!kIsWeb) {
                        if (Platform.isIOS ||
                            Platform.isAndroid ||
                            Platform.isMacOS) {
                          bool status = await Permission.storage.isGranted;

                          if (!status) await Permission.storage.request();
                        }
                      }
                      Uint8List? data = await UtilsService.export(urlPath);
                      if (data != null) {
                        MimeType type = MimeType.MICROSOFTEXCEL;
                        String path = await FileSaver.instance
                            .saveFile("primas", data, "xlsx", mimeType: type);
                        if (kDebugMode) {
                          print(path);
                        }
                      } else {
                        NotificationService.showSnackbarError(
                            'No se pudo descargar el excel');
                      }
                    },
                  ),
                  CustomButtonPrimary(
                    title: "Importar Primas",
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        // allowedExtensions: ['jpg'],
                        allowMultiple: false,
                      );

                      if (result != null) {
                        final resp = await UtilsService.import(
                            urlPath, result.files.first);
                        if (resp != null) {
                          setState(() {
                            NotificationService.showSnackbarSuccess(
                                'Carga masiva Exitosa');
                          });
                        } else {
                          NotificationService.showSnackbarError(
                              'No fue posible cargar la información');
                        }
                      } else {
                        // Coverager canceled the picker
                      }
                    },
                  )
                ],
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
                  'query': '{id, description}'
                }),
                builder: (context, AsyncSnapshot<PlansUses?> snapshot) {
                  if (snapshot.hasData) {
                    plansAndUses = snapshot.data!;
                  }
                  return snapshot.connectionState == ConnectionState.done
                      ? GenericTable(
                          withSearchEngine: false,
                          dataRowHeight: 120,
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
                                      Plan planMap = Plan.fromMap(plan);
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FutureBuilder(
                                              future: UseService.getUse(
                                                  use.id!, planMap.id),
                                              builder: (_,
                                                  AsyncSnapshot<Use?>
                                                      snapshot) {
                                                return snapshot
                                                            .connectionState ==
                                                        ConnectionState.done
                                                    ? TotalCoverage(
                                                        plan: planMap,
                                                        use: snapshot.data!,
                                                        premiums: snapshot
                                                            .data!.premiums!,
                                                      )
                                                    : const MyProgressIndicator();
                                              }),
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
              showMaterialModalBottomSheet(
                expand: true,
                context: context,
                builder: (_) => PremiumModal(
                  plan: widget.plan,
                  use: widget.use,
                ),
              );
            },
          ),
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
