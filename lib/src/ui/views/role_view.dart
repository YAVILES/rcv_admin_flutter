import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';

import 'package:rcv_admin_flutter/src/models/role_model.dart';
import 'package:rcv_admin_flutter/src/models/workflow_model.dart';
import 'package:rcv_admin_flutter/src/providers/role_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/workflow_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/chips/custom_chip.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class RoleView extends StatefulWidget {
  Role? role;

  RoleView({
    Key? key,
    this.role,
  }) : super(key: key);

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  @override
  void initState() {
    Provider.of<RoleProvider>(context, listen: false).role =
        widget.role ?? Role();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Sistema',
              subtitle: 'Rol ${widget.role?.name ?? ''}',
            ),
            const _RoleForm(),
          ],
        ),
      ),
    );
  }
}

class _RoleForm extends StatefulWidget {
  const _RoleForm({Key? key}) : super(key: key);

  @override
  State<_RoleForm> createState() => _RoleFormState();
}

class _RoleFormState extends State<_RoleForm> {
  @override
  void initState() {
    Provider.of<RoleProvider>(context, listen: false).formRoleKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoleProvider roleProvider = Provider.of<RoleProvider>(context);
    return Form(
      key: roleProvider.formRoleKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: roleProvider.role!.name,
            onChanged: (value) => roleProvider.role!.name = value,
            decoration: CustomInputs.buildInputDecoration(
              hintText: 'Ingrese el Nombre',
              labelText: 'Nombre',
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: WorkFlowService.getWorkFlows({'not_paginator': true}),
            builder: (_, AsyncSnapshot<List<Workflow>> snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? Row(
                      children: [
                        const Text('WorkFlows'),
                        const SizedBox(width: 20),
                        Wrap(
                          children: [
                            ...snapshot.data!.map(
                              (w) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CustomChip(
                                  active: roleProvider.role!.workflows!
                                      .contains(w.id!),
                                  onTap: (active) {
                                    if (active) {
                                      roleProvider.role!.workflows != null
                                          ? roleProvider.role!.workflows!
                                              .add(w.id!)
                                          : roleProvider.role!.workflows = [
                                              w.id!
                                            ];
                                    } else {
                                      if (roleProvider.role!.workflows !=
                                          null) {
                                        roleProvider.role!.workflows!
                                            .remove(w.id!);
                                      }
                                    }
                                  },
                                  title: w.title!,
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
            width: 150,
            child: CustomCheckBox(
              value: roleProvider.role!.isActive ?? true,
              onChanged: (value) => roleProvider.role!.isActive = value,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButtonPrimary(
              onPressed: () async {
                try {
                  final bool create = roleProvider.role!.id == null;

                  if (create) {
                    await roleProvider.newRole(roleProvider.role!);
                    NotificationService.showSnackbarSuccess(
                        '${roleProvider.role!.name} creado');
                  } else {
                    await roleProvider.editRole(
                      int.parse(roleProvider.role!.id!.toString()),
                      roleProvider.role!,
                    );
                    NotificationService.showSnackbarSuccess(
                      '${roleProvider.role!.name} actualizado',
                    );
                  }
                  NavigationService.back(context);
                } catch (e) {
                  NotificationService.showSnackbarError(
                    'No se pudo guardar el role',
                  );
                }
              },
              title: 'Guardar',
            ),
          ),
        ],
      ),
    );
  }
}
