import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/generic_table_responsive.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/bank_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:responsive_table/responsive_table.dart';

class BanksView extends StatefulWidget {
  const BanksView({Key? key}) : super(key: key);

  @override
  State<BanksView> createState() => _BanksViewState();
}

class _BanksViewState extends State<BanksView> {
  late List<DatatableHeader> _headers;

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(text: "Código", value: "code"),
      DatatableHeader(text: "Descripción", value: "description"),
      DatatableHeader(
          text: "Modenas", value: "coins_display", textAlign: TextAlign.left),
      DatatableHeader(text: "Métodos de Pago", value: "methods_display"),
      DatatableHeader(text: "Estatus", value: "status_display"),
      DatatableHeader(
        text: "Acciones",
        value: "id",
        sourceBuilder: (value, row) {
          return _ActionsTable(item: row);
        },
      )
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        child: CenteredView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              HeaderView(
                title: "Administración de Pagos",
                subtitle: "Bancos",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () =>
                        NavigationService.navigateTo(context, bankRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              GenericTableResponsive(
                headers: _headers,
                onSource: (Map<String, dynamic> params, String? url) {
                  return BankService.getBanksPaginated(params, url);
                },
                onExport: (params) {
                  return BankService.export();
                },
                filenameExport: "bancos",
                // ignore: prefer_const_literals_to_create_immutables
                params: {
                  "query": """{id, code, description, image, image_display, 
                  coins, coins_display, methods, methods_display, status, 
                  status_display}"""
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
  Map<String?, dynamic> item;
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
              bankDetailRoute,
              {'id': item['id'].toString()},
            );
          },
        ),
      ],
    );
  }
}
