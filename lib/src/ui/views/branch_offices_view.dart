import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/providers/branch_office_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class BranchOfficesView extends StatefulWidget {
  const BranchOfficesView({Key? key}) : super(key: key);

  @override
  State<BranchOfficesView> createState() => _BranchOfficesViewState();
}

class _BranchOfficesViewState extends State<BranchOfficesView> {
  @override
  void initState() {
    Provider.of<BranchOfficeProvider>(context, listen: false)
        .getBranchOffices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final branchOffices =
        Provider.of<BranchOfficeProvider>(context).branchOffices;
    return CenteredView(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          HeaderView(
            title: "Administración de Sistema",
            subtitle: "Sucursales",
            actions: [
              CustomButtonPrimary(
                onPressed: () => NavigationService.navigateTo(
                    context, branchOfficeRoute, null),
                title: 'Nueva',
              )
            ],
          ),
          GenericTable(
            data: branchOffices,
            columns: [
              DTColumn(
                header: "Nro",
                dataAttribute: 'number',
              ),
              DTColumn(
                header: "Código",
                dataAttribute: 'code',
              ),
              DTColumn(
                header: "Descripción",
                dataAttribute: 'description',
              ),
              DTColumn(
                header: "Fecha de creación",
                dataAttribute: 'created',
                type: TypeColumn.dateTime,
              ),
              DTColumn(
                header: "Fecha ult. actualización",
                dataAttribute: 'created',
                type: TypeColumn.dateTime,
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
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _ActionsTable extends StatelessWidget {
  _ActionsTable({
    Key? key,
    required this.item,
  }) : super(key: key);

  Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            NavigationService.navigateTo(
              context,
              branchOfficeDetailRoute,
              {'id': item['id']},
            );
          },
        ),
      ],
    );
  }
}
