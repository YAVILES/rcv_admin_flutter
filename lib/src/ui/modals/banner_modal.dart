import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class BannerModal extends StatefulWidget {
  final BannerRCV? banner;

  const BannerModal({Key? key, this.banner}) : super(key: key);

  @override
  State<BannerModal> createState() => _BannerModalState();
}

class _BannerModalState extends State<BannerModal> {
  late BannerRCV _banner;
  @override
  void initState() {
    super.initState();
    _banner = widget.banner ?? BannerRCV();
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = Provider.of<BannerRCVProvider>(context);
    return Container(
      height: 500,
      decoration: buildBoxDecoration(context),
      child: CenteredView(
        child: Column(
          children: [
            const HeaderView(),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _banner.title ?? '',
              onChanged: (value) => _banner.title = value,
              decoration: const InputDecoration(
                hintText: 'Ingrese el titulo',
                labelText: 'titulo',
              ),
            ),
            TextFormField(
              initialValue: _banner.subtitle ?? '',
              onChanged: (value) => _banner.subtitle = value,
              decoration: const InputDecoration(
                hintText: 'Ingrese el subtitulo',
                labelText: 'Sub titulo',
              ),
            ),
            TextFormField(
              initialValue: _banner.content ?? '',
              onChanged: (value) => _banner.content = value,
              decoration: const InputDecoration(
                hintText: 'Ingrese el contenido',
                labelText: 'Contenido',
              ),
            ),
            TextFormField(
              initialValue: _banner.url ?? '',
              onChanged: (value) => _banner.url = value,
              decoration: const InputDecoration(
                hintText: 'Ingrese la url',
                labelText: 'Url',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: CustomButton(onPressed: () async {
                try {
                  if (_banner.id == null) {
                    await bannerProvider.newBanner(_banner);
                    NotificationService.showSnackbarSuccess(
                        '${_banner.title} creado');
                  } else {
                    await bannerProvider.editBanner(_banner.id!, _banner);
                    NotificationService.showSnackbarSuccess(
                      '${_banner.title} actualizado',
                    );
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  NotificationService.showSnackbarSuccess(
                    'No se pudo guardar el banner',
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      color: Theme.of(context).primaryColor,
      boxShadow: const [
        BoxShadow(color: Colors.black26),
      ],
    );
  }
}
