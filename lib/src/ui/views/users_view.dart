import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/chips/custom_chip.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class UsersView extends StatefulWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final loading = userProvider.loading;
    final users = userProvider.users;
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
                  subtitle: "Usuarios",
                  actions: [
                    CustomButtonPrimary(
                      onPressed: () => NavigationService.navigateTo(
                          context, userRoute, null),
                      title: 'Nuevo',
                    )
                  ],
                ),
                (loading == true)
                    ? const MyProgressIndicator()
                    : GenericTable(
                        data: users,
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
                            header: "Usuario",
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
                        onSearch: (value) {
                          userProvider.search(value);
                        },
                        searchInitialValue: userProvider.searchValue,
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
              userDetailRoute,
              {'id': item['id']},
            );
          },
        ),
      ],
    );
  }
}
