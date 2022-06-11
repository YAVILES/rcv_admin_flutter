import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/components/generic_table_responsive.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/bank_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
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
  Future<ResponseData?> Function(Map<String, dynamic>, String?) onSource =
      (params, url) => BankService.getBanksPaginated(params, url);

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(text: "Código", value: "code"),
      DatatableHeader(text: "Descripción", value: "description"),
      DatatableHeader(
          text: "Modenas", value: "coins_display", textAlign: TextAlign.left),
      DatatableHeader(
          text: "Métodos de Pago",
          value: "methods_display",
          textAlign: TextAlign.left),
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
                  return onSource(params, url);
                },
                onExport: (params) {
                  return BankService.export();
                },
                onImport: (params) async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    // allowedExtensions: ['jpg'],
                    allowMultiple: false,
                  );

                  if (result != null) {
                    final resp = await BankService.import(result.files.first);
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
                    // User canceled the picker
                  }
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
