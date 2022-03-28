import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/client_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class ClientsView extends StatefulWidget {
  const ClientsView({Key? key}) : super(key: key);

  @override
  State<ClientsView> createState() => _ClientsViewState();
}

class _ClientsViewState extends State<ClientsView> {
  @override
  void initState() {
    Provider.of<ClientProvider>(context, listen: false).getClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);
    final loading = clientProvider.loading;
    final clients = clientProvider.clients;
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
                  subtitle: "Gestión de Clientes",
                  actions: [
                    CustomButtonPrimary(
                      onPressed: () => NavigationService.navigateTo(
                          context, clientRoute, null),
                      title: 'Nuevo',
                    )
                  ],
                ),
                (loading == true)
                    ? const MyProgressIndicator()
                    : GenericTable(
                        data: clients,
                        columns: [
                          DTColumn(
                            header: "Foto",
                            dataAttribute: 'photo',
                            onSort: false,
                            widget: (item) => Container(
                              constraints: const BoxConstraints(maxWidth: 50),
                              margin: const EdgeInsets.all(5),
                              child: Hero(
                                tag: item['id'],
                                child: ClipOval(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(maxWidth: 30),
                                    child: item['photo'] != null
                                        ? FadeInImage(
                                            image: NetworkImage(
                                              item['photo'],
                                              headers: {
                                                'accept': '*/*',
                                              },
                                            ),
                                            placeholder: const AssetImage(
                                                'assets/images/img_avatar.png'),
                                          )
                                        : Image.asset(
                                            'assets/images/img_avatar.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DTColumn(
                            header: "Cliente",
                            dataAttribute: 'username',
                          ),
                          DTColumn(
                            header: "Nombre",
                            dataAttribute: 'full_name',
                            widget: (item) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name']),
                                Text(item['last_name'])
                              ],
                            ),
                          ),
                          DTColumn(
                            header: "Correo",
                            dataAttribute: 'email',
                          ),
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
                          clientProvider.search(value);
                        },
                        searchInitialValue: clientProvider.searchValue,
                      ),
              ],
            ),
          )),
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
              clientDetailRoute,
              {'id': item['id']},
            );
          },
        ),
      ],
    );
  }
}
