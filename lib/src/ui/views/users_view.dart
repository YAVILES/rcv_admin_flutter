import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/providers/user_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
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
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context).users;

    return CenteredView(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          HeaderView(
            title: "Administración de Sistema",
            subtitle: "Usuarios",
            actions: [
              CustomButtonPrimary(
                onPressed: () =>
                    NavigationService.navigateTo(context, userRoute, null),
                title: 'Nuevo',
              )
            ],
          ),
          GenericTable(
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
                        : Image.asset('assets/images/img_avatar.png',
                            width: 30, height: 30),
                  ),
                ),

                /*             Image.network(
                          item['photo'].toString(),
                          width: 30,
                          height: 30,
                          loadingBuilder: (context, __, ___) =>
                              const MyProgressIndicator(),
                          errorBuilder: (_, data, ___) {
                            print(data);
                            return Image.asset(
                              'images/img_avatar.png',
                              width: 30,
                              height: 30,
                            );
                          },
                        ) */
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
              usersRoute,
              {'id': item['id']},
            );
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
                    await Provider.of<UserProvider>(context, listen: false)
                        .deleteUser(item['id']);
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
