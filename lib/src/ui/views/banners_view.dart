import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/components/generic_table/classes.dart';
import 'package:rcv_admin_flutter/src/components/generic_table/generic_table.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/ui/modals/banner_modal.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';

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
    final banners = Provider.of<BannerRCVProvider>(context).banners;

    return CenteredView(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          GenericTable(
            data: banners,
            columns: [
              DTColumn(header: "Id", dataAttribute: 'id', onSort: false),
              DTColumn(header: "Titulo", dataAttribute: 'title'),
              DTColumn(header: "Sub Titulo", dataAttribute: 'subtitle'),
              DTColumn(header: "Contenido", dataAttribute: 'content'),
              DTColumn(header: "Url", dataAttribute: 'url'),
              DTColumn(
                header: "Acciones",
                dataAttribute: 'id',
                widget: (item) {
                  return _ActionsTable(item: item);
                },
                onSort: false,
              ),
            ],
            newTitle: 'Crear Banner',
            onNewPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => const BannerModal(banner: null),
              );
            },
          )
        ],
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
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) => BannerModal(banner: BannerRCV.fromMap(item)),
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
                    await Provider.of<BannerRCVProvider>(context, listen: false)
                        .deleteBanner(item['id']);
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
