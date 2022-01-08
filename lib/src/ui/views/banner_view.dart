import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/providers/banner_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class BannerView extends StatefulWidget {
  BannerRCV? banner;

  BannerView({
    Key? key,
    this.banner,
  }) : super(key: key);

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  @override
  void initState() {
    Provider.of<BannerRCVProvider>(context, listen: false).banner =
        widget.banner ?? BannerRCV();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CenteredView(
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          HeaderView(
            title: 'Administración Web',
            subtitle: 'Banner ${widget.banner?.title ?? ''}',
          ),
          const _BannerForm(),
        ],
      ),
    );
  }
}

class _BannerForm extends StatefulWidget {
  const _BannerForm({Key? key}) : super(key: key);

  @override
  State<_BannerForm> createState() => _BannerFormState();
}

class _BannerFormState extends State<_BannerForm> {
  PlatformFile? image;

  @override
  void initState() {
    Provider.of<BannerRCVProvider>(context, listen: false).formBannerKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BannerRCVProvider bannerProvider = Provider.of<BannerRCVProvider>(context);
    return Column(
      children: [
        Stack(
          children: [
            Hero(
              tag: bannerProvider.banner?.id ?? 'newBanner',
              child: (image?.bytes != null)
                  ? Image.memory(Uint8List.fromList(image!.bytes!))
                  : bannerProvider.banner?.image != null
                      ? Image.network(bannerProvider.banner!.image!)
                      : Image.asset('assets/images/upload.png'),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white, width: 5),
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.indigo,
                  elevation: 0,
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      // allowedExtensions: ['jpg'],
                      allowMultiple: false,
                    );

                    if (result != null) {
                      setState(() => image = result.files.first);

                      /*  print(file.name);
                          print(file.bytes);
                          print(file.size);
                          print(file.extension);
                          // print(file.path); */
                      /*    await userFormProvider.uploadImage(
                              'security/user/${user?.id}', file.bytes!); */
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Icon(Icons.upload_file_outlined),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Form(
          key: bannerProvider.formBannerKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: bannerProvider.banner!.title,
                onChanged: (value) => bannerProvider.banner!.title = value,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el titulo',
                  labelText: 'titulo',
                ),
              ),
              TextFormField(
                initialValue: bannerProvider.banner!.subtitle,
                onChanged: (value) => bannerProvider.banner!.subtitle = value,
                decoration: const InputDecoration(
                  hintText: 'Ingrese el subtitulo',
                  labelText: 'Sub titulo',
                ),
              ),
              TextFormField(
                initialValue: bannerProvider.banner!.content,
                onChanged: (value) => bannerProvider.banner!.content = value,
                onFieldSubmitted: (value) {},
                decoration: const InputDecoration(
                  hintText: 'Ingrese el contenido',
                  labelText: 'Contenido',
                ),
              ),
              TextFormField(
                initialValue: bannerProvider.banner!.url ?? '',
                onChanged: (value) => bannerProvider.banner!.url = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La url es obligatoria';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Ingrese la url',
                  labelText: 'Url',
                ),
              ),
              CustomCheckBox(
                value: bannerProvider.banner!.isActive ?? true,
                onChanged: (value) => bannerProvider.banner!.isActive = value,
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: CustomButtonPrimary(
                  onPressed: () async {
                    try {
                      final bool create = bannerProvider.banner!.id == null;

                      if (create) {
                        await bannerProvider.newBanner(
                            bannerProvider.banner!, image);
                        NotificationService.showSnackbarSuccess(
                            '${bannerProvider.banner!.title} creado');
                      } else {
                        await bannerProvider.editBanner(
                            bannerProvider.banner!.id!,
                            bannerProvider.banner!,
                            image);
                        NotificationService.showSnackbarSuccess(
                          '${bannerProvider.banner!.title} actualizado',
                        );
                      }
                      NavigationService.backTo(context);
                    } catch (e) {
                      NotificationService.showSnackbarError(
                        'No se pudo guardar el banner',
                      );
                    }
                  },
                  title: 'Guardar',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
