import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';

import 'package:rcv_admin_flutter/src/models/section_model.dart';
import 'package:rcv_admin_flutter/src/providers/section_provider.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/section_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';

class SectionView extends StatefulWidget {
  Section? section;
  String? uid;
  SectionView({
    Key? key,
    this.section,
    this.uid,
  }) : super(key: key);

  @override
  State<SectionView> createState() => _SectionViewState();
}

class _SectionViewState extends State<SectionView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración Web',
              subtitle: 'Sección ${widget.section?.title ?? ''}',
            ),
            SectionForm(uid: widget.uid, section: widget.section),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SectionForm extends StatefulWidget {
  String? uid;
  Section? section;
  SectionForm({Key? key, this.section, this.uid}) : super(key: key);

  @override
  State<SectionForm> createState() => _SectionFormState();
}

class _SectionFormState extends State<SectionForm> {
  PlatformFile? image;
  PlatformFile? shape;
  PlatformFile? icon;

  @override
  void initState() {
    if (widget.uid != null) {
      Provider.of<SectionProvider>(context, listen: false)
          .getSection(widget.uid!);
    } else {
      Provider.of<SectionProvider>(context, listen: false).section =
          widget.section ?? Section();
    }
    Provider.of<SectionProvider>(context, listen: false).formSectionKey =
        GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SectionProvider sectionProvider =
        Provider.of<SectionProvider>(context, listen: false);
    return Column(
      children: [
        const SizedBox(height: 20),
        Form(
          key: sectionProvider.formSectionKey,
          child: Column(
            children: [
              FutureBuilder(
                future: SectionService.getTypes(),
                builder: (_, AsyncSnapshot<List<Option>?> snapshot) {
                  return snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Consumer<SectionProvider>(
                              builder: (context, obj, child) {
                            return DropdownSearch<Option>(
                              enabled: obj.section?.id == null,
                              selectedItem: obj.type,
                              items: snapshot.data!,
                              dropdownSearchDecoration: const InputDecoration(
                                hintText: "Seleccione el tipo de sección",
                                labelText: "Tipo",
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 0, 0),
                                border: OutlineInputBorder(),
                              ),
                              itemAsString: (Option? type) =>
                                  '${type?.description}',
                              onChanged: (Option? data) {
                                sectionProvider.setType(data);
                              },
                              validator: (Option? item) {
                                if (item == null) {
                                  return "Debe seleccionar la moneda obligatoriamente";
                                } else {
                                  return null;
                                }
                              },
                            );
                          }),
                        )
                      : const MyProgressIndicator();
                },
              ),
              Consumer<SectionProvider>(builder: (context, obj, child) {
                return Column(
                  children: [
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Hero(
                                  tag: sectionProvider.section?.id ??
                                      'newSection',
                                  child: (image?.bytes != null)
                                      ? Image.memory(
                                          Uint8List.fromList(image!.bytes!),
                                          fit: BoxFit.contain)
                                      : sectionProvider.section?.imageDisplay !=
                                              null
                                          ? Image.network(
                                              sectionProvider
                                                  .section!.imageDisplay!,
                                              fit: BoxFit.contain)
                                          : Image.asset(
                                              'assets/images/upload.png',
                                              fit: BoxFit.contain),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: Colors.white, width: 5),
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
                                        setState(
                                            () => image = result.files.first);

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
                                    child:
                                        const Icon(Icons.upload_file_outlined),
                                  ),
                                ),
                              ),
                              const Text('Imagen')
                            ],
                          ),
                        ),
                        if (sectionProvider.type?.value ==
                            SectionService.box) ...[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: (shape?.bytes != null)
                                      ? Image.memory(
                                          Uint8List.fromList(shape!.bytes!),
                                          fit: BoxFit.contain)
                                      : sectionProvider.section?.shapeDisplay !=
                                              null
                                          ? Image.network(
                                              sectionProvider
                                                  .section!.shapeDisplay!,
                                              fit: BoxFit.contain)
                                          : Image.asset(
                                              'assets/images/upload.png',
                                              fit: BoxFit.contain),
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: Colors.white, width: 5),
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
                                          setState(
                                              () => shape = result.files.first);

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
                                      child: const Icon(
                                          Icons.upload_file_outlined),
                                    ),
                                  ),
                                ),
                                const Text('Imagen Forma')
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: (icon?.bytes != null)
                                      ? Image.memory(
                                          Uint8List.fromList(icon!.bytes!),
                                          fit: BoxFit.contain)
                                      : sectionProvider.section?.iconDisplay !=
                                              null
                                          ? Image.network(
                                              sectionProvider
                                                  .section!.iconDisplay!,
                                              fit: BoxFit.contain)
                                          : Image.asset(
                                              'assets/images/upload.png',
                                              fit: BoxFit.contain),
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: Colors.white, width: 5),
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
                                          setState(
                                              () => icon = result.files.first);

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
                                      child: const Icon(
                                          Icons.upload_file_outlined),
                                    ),
                                  ),
                                ),
                                const Text('Icono')
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                    TextFormField(
                      initialValue: sectionProvider.section!.title,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El titulo es obligatorio';
                        }
                        return null;
                      },
                      onChanged: (value) =>
                          sectionProvider.section!.title = value,
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el titulo',
                        labelText: 'Titulo',
                      ),
                    ),
                    TextFormField(
                      initialValue: sectionProvider.section!.subtitle,
                      onChanged: (value) =>
                          sectionProvider.section!.subtitle = value,
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el sub titulo',
                        labelText: 'Sub titulo',
                      ),
                    ),
                    TextFormField(
                      initialValue: sectionProvider.section!.content,
                      onChanged: (value) =>
                          sectionProvider.section!.content = value,
                      onFieldSubmitted: (value) {},
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese el contenido',
                        labelText: 'Contenido',
                      ),
                    ),
                    TextFormField(
                      initialValue: sectionProvider.section!.url ?? '',
                      onChanged: (value) =>
                          sectionProvider.section!.url = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La url es obligatoria';
                        }
                        return null;
                      },
                      decoration: CustomInputs.buildInputDecoration(
                        hintText: 'Ingrese la  url',
                        labelText: 'Url',
                      ),
                    ),
                    CustomCheckBox(
                      value: sectionProvider.section!.isActive ?? true,
                      onChanged: (value) =>
                          sectionProvider.section!.isActive = value,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      alignment: Alignment.center,
                      child: CustomButtonPrimary(
                        onPressed: () async {
                          try {
                            final bool create =
                                sectionProvider.section!.id == null;

                            if (create) {
                              await sectionProvider.newSection(
                                  sectionProvider.section!, image, shape, icon);
                              NotificationService.showSnackbarSuccess(
                                  '${sectionProvider.section!.title} creado');
                            } else {
                              await sectionProvider.editSection(
                                  sectionProvider.section!.id!,
                                  sectionProvider.section!,
                                  image,
                                  shape,
                                  icon);
                              NotificationService.showSnackbarSuccess(
                                '${sectionProvider.section!.title} actualizado',
                              );
                            }
                            NavigationService.back(context);
                          } catch (e) {
                            NotificationService.showSnackbarError(
                              'No se pudo guardar el section',
                            );
                          }
                        },
                        title: 'Guardar',
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
