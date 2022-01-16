import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/router/route_names.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/modals/banner_modal.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BannersView extends StatefulWidget {
  const BannersView({Key? key}) : super(key: key);

  @override
  State<BannersView> createState() => _BannersViewState();
}

class _BannersViewState extends State<BannersView> {
  @override
  void initState() {
    super.initState();
    Provider.of<BannerRCVProvider>(context, listen: false).getBanners();
  }

  @override
  Widget build(BuildContext context) {
    final bannerRCVProvider = Provider.of<BannerRCVProvider>(context);
    final loading = bannerRCVProvider.loading;
    final banners = bannerRCVProvider.banners;

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
                title: "Administración Web",
                subtitle: "Banners",
                actions: [
                  CustomButtonPrimary(
                    onPressed: () => NavigationService.navigateTo(
                        context, bannerRoute, null),
                    title: 'Nuevo',
                  )
                ],
              ),
              (loading == true)
                  ? const MyProgressIndicator()
                  : GenericTable(
                      showCheckboxColumn: true,
                      onSelectChanged: (data) => print(data.item.toString()),
                      onDeleteSelectedItems: (items) {
                        final dialog = AlertDialog(
                          title: const Text(
                              '¿Estas seguro de eliminar los items seleccionados?'),
                          content:
                              const Text('Definitivamente deseas eliminar'),
                          actions: [
                            TextButton(
                              child: const Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("Si, eliminar"),
                              onPressed: () async {
                                try {
                                  final deleted =
                                      await Provider.of<BannerRCVProvider>(
                                              context,
                                              listen: false)
                                          .deleteBanners(items
                                              .map((e) => e['id'].toString())
                                              .toList());
                                  if (deleted) {
                                    NotificationService.showSnackbarSuccess(
                                        'Banners eliminado con exito.');
                                  } else {
                                    NotificationService.showSnackbarSuccess(
                                        'No se pudieron eliminar los banners.');
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
                      data: banners,
                      columns: [
                        DTColumn(
                          header: "Imagen",
                          dataAttribute: 'image',
                          onSort: false,
                          widget: (item) => Container(
                            constraints: const BoxConstraints(maxWidth: 50),
                            margin: const EdgeInsets.all(5),
                            child: Hero(
                              tag: item['id'],
                              child: item['image'] != null
                                  ? FadeInImage(
                                      image: NetworkImage(
                                        item['image'],
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
                          item['image'].toString(),
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
                        DTColumn(header: "Titulo", dataAttribute: 'title'),
                        DTColumn(
                            header: "Sub Titulo", dataAttribute: 'subtitle'),
                        DTColumn(header: "Contenido", dataAttribute: 'content'),
                        DTColumn(header: "Url", dataAttribute: 'url'),
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
                        bannerRCVProvider.search(value);
                      },
                      searchInitialValue: bannerRCVProvider.searchValue,
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
              bannerDetailRoute,
              {'id': item['id']},
            );
            /*           showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) => BannerModal(banner: BannerRCV.fromMap(item)),
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
                      final deleted = await Provider.of<BannerRCVProvider>(
                              context,
                              listen: false)
                          .deleteBanner(item['id']);
                      if (deleted) {
                        NotificationService.showSnackbarSuccess(
                            'Banner eliminado con exito.');
                      } else {
                        NotificationService.showSnackbarSuccess(
                            'No se pudo eliminar el banner.');
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
