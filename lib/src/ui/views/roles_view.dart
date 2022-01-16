import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/role_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/chips/custom_chip.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class RolesView extends StatefulWidget {
  const RolesView({Key? key}) : super(key: key);

  @override
  State<RolesView> createState() => _RolesViewState();
}

class _RolesViewState extends State<RolesView> {
  @override
  void initState() {
    super.initState();
    Provider.of<RoleProvider>(context, listen: false).getRoles();
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);
    final loading = roleProvider.loading;
    final roles = roleProvider.roles;

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
                subtitle: "Roles",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () =>
                        NavigationService.navigateTo(context, roleRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              (loading == true)
                  ? const MyProgressIndicator()
                  : GenericTable(
                      data: roles,
                      columns: [
                        DTColumn(header: "Id", dataAttribute: 'id'),
                        DTColumn(header: "Nombre", dataAttribute: 'name'),
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
                        roleProvider.search(value);
                      },
                      searchInitialValue: roleProvider.searchValue,
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
              roleDetailRoute,
              {'id': item['id'].toString()},
            );
            /*           showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) => RoleModal(role: Role.fromMap(item)),
            ); */
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outlined),
          color: Colors.red,
          onPressed: () {
            final dialog = AlertDialog(
              title: const Text('¿Estas seguro de eliminar?'),
              content: const Text('Definitivamente deseas borrar'),
              actions: [
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Si, borrar"),
                  onPressed: () async {
                    try {
                      final deleted = await Provider.of<RoleProvider>(context,
                              listen: false)
                          .deleteRole(item['id']);
                      if (deleted) {
                        NotificationService.showSnackbarSuccess(
                            'Role eliminado con exito.');
                      } else {
                        NotificationService.showSnackbarSuccess(
                            'No se pudo eliminar el role.');
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
        ),
      ],
    );
  }
}
