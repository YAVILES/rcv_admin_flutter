import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/providers/banner_form_provider.dart';
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
    Provider.of<BannerFormProvider>(context, listen: false).banner =
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
  Widget build(BuildContext context) {
    BannerFormProvider bannerFormProvider =
        Provider.of<BannerFormProvider>(context);
    return Column(
      children: [
        Stack(
          children: [
            Hero(
              tag: bannerFormProvider.banner?.id ?? 'newBanner',
              child: (image?.bytes != null)
                  ? Image.memory(Uint8List.fromList(image!.bytes!))
                  : bannerFormProvider.banner?.image != null
                      ? Image.network(bannerFormProvider.banner!.image!)
                      : Image.asset('images/upload.png'),
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
        TextFormField(
          initialValue: bannerFormProvider.banner!.title,
          onChanged: (value) => bannerFormProvider.banner!.title = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese el titulo',
            labelText: 'titulo',
          ),
        ),
        TextFormField(
          initialValue: bannerFormProvider.banner!.subtitle,
          onChanged: (value) => bannerFormProvider.banner!.subtitle = value,
          decoration: const InputDecoration(
            hintText: 'Ingrese el subtitulo',
            labelText: 'Sub titulo',
          ),
        ),
        TextFormField(
          initialValue: bannerFormProvider.banner!.content,
          onChanged: (value) => bannerFormProvider.banner!.content = value,
          onFieldSubmitted: (value) {},
          decoration: const InputDecoration(
            hintText: 'Ingrese el contenido',
            labelText: 'Contenido',
          ),
        ),
        TextFormField(
          initialValue: bannerFormProvider.banner!.url ?? '',
          onChanged: (value) => bannerFormProvider.banner!.url = value,
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
          value: bannerFormProvider.banner!.isActive ?? true,
          onChanged: (value) => bannerFormProvider.banner!.isActive = value,
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: CustomButtonPrimary(
            onPressed: () async {
              try {
                final bool create = bannerFormProvider.banner!.id == null;
                final saved = await bannerFormProvider.saveData(
                    bannerFormProvider.banner!, image);
                if (saved) {
                  NavigationService.backTo(context);
                  if (create) {
                    NotificationService.showSnackbarSuccess(
                        '${bannerFormProvider.banner!.title} creado');
                  } else {
                    NotificationService.showSnackbarSuccess(
                      '${bannerFormProvider.banner!.title} actualizado',
                    );
                  }
                }
              } catch (e) {
                NavigationService.backTo(context);
                NotificationService.showSnackbarError(
                  'No se pudo guardar el banner',
                );
              }
            },
            title: 'Guardar',
          ),
        ),
      ],
    );
  }
}
