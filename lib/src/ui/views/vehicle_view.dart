import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rcv_admin_flutter/src/components/document_vehicle.dart';
import 'package:rcv_admin_flutter/src/components/my_progress_indicator.dart';
import 'package:rcv_admin_flutter/src/models/model_model.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/use_model.dart';

import 'package:rcv_admin_flutter/src/models/vehicle_model.dart';
import 'package:rcv_admin_flutter/src/providers/vehicle_provider.dart';
import 'package:rcv_admin_flutter/src/services/mark_service.dart';
import 'package:rcv_admin_flutter/src/services/model_service.dart';
import 'package:rcv_admin_flutter/src/services/navigation_service.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/services/use_service.dart';
import 'package:rcv_admin_flutter/src/services/vehicle_service.dart';
import 'package:rcv_admin_flutter/src/ui/buttons/custom_button_primary.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_check_box.dart';
import 'package:rcv_admin_flutter/src/ui/inputs/custom_inputs.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/centered_view.dart';
import 'package:rcv_admin_flutter/src/ui/shared/widgets/header_view.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

import '../../models/mark_model.dart';

class VehicleView extends StatefulWidget {
  Vehicle? vehicle;
  String? uid;
  bool? modal;

  VehicleView({
    Key? key,
    this.vehicle,
    this.uid,
    this.modal = false,
  }) : super(key: key);

  @override
  State<VehicleView> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView> {
  @override
  Widget build(BuildContext context) {
    if (widget.vehicle != null) {
      return _VehicleViewBody(vehicle: widget.vehicle!, modal: widget.modal);
    } else {
      return FutureBuilder(
        future: Provider.of<VehicleProvider>(context, listen: false)
            .getVehicle(widget.uid ?? ''),
        builder: (_, AsyncSnapshot snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? _VehicleViewBody(vehicle: snapshot.data, modal: widget.modal)
              : const MyProgressIndicator();
        },
      );
    }
  }
}

class _VehicleViewBody extends StatefulWidget {
  Vehicle vehicle;
  List<Model> models = [];
  String? mark;
  PlatformFile? identityCardImage;
  bool? modal;

  _VehicleViewBody({
    Key? key,
    required this.vehicle,
    this.modal = false,
  }) : super(key: key);

  @override
  __VehicleViewBodyState createState() => __VehicleViewBodyState();
}

class __VehicleViewBodyState extends State<_VehicleViewBody> {
  @override
  void initState() {
    Provider.of<VehicleProvider>(context, listen: false).formVehicleKey =
        GlobalKey<FormState>();
    Provider.of<VehicleProvider>(context, listen: false).vehicle =
        widget.vehicle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VehicleProvider vehicleProvider = Provider.of<VehicleProvider>(context);
    Vehicle _vehicle = vehicleProvider.vehicle!;
    final bool create = widget.vehicle.id == null;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: CenteredView(
        child: Column(
          children: [
            HeaderView(
              title: 'Administración de Vehículos',
              subtitle: 'Vehículo ${widget.vehicle.licensePlate ?? ''}',
              modal: widget.modal,
            ),
            Column(
              children: [
                Form(
                  key: vehicleProvider.formVehicleKey,
                  child: Column(
                    children: [
                      const Text('Datos del Vehiculo'),
                      TextFormField(
                        initialValue: _vehicle.licensePlate ?? '',
                        onChanged: (value) => _vehicle.licensePlate = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La placa es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la placa.',
                          labelText: 'Placa',
                        ),
                      ),
                      FutureBuilder(
                        future: MarkService.getMarks({
                          'query': '{id, description}',
                          'not_paginator': true
                        }),
                        builder:
                            (context, AsyncSnapshot<List<Mark>?> snapshot) {
                          return snapshot.connectionState !=
                                  ConnectionState.done
                              ? const MyProgressIndicator()
                              : DropdownButtonFormField(
                                  decoration: CustomInputs.buildInputDecoration(
                                    labelText: 'Marca',
                                  ),
                                  hint: const Text("Seleccione la marca "),
                                  // Initial Value
                                  value: _vehicle.modelDisplay?.mark ??
                                      widget.mark,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: snapshot.data?.map((Mark item) {
                                    return DropdownMenuItem(
                                      value: item.id,
                                      child: Text(item.description!),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? value) {
                                    widget.mark = value;
                                    ModelService.getModels({
                                      'mark': value,
                                      'not_paginator': true,
                                      'query': '{id, description}'
                                    }).then((List<Model> result) =>
                                        setState(() => widget.models = result));
                                  },

                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'La marca es obligatoria';
                                    }
                                    return null;
                                  },
                                );
                        },
                      ),
                      DropdownButtonFormField(
                        decoration: CustomInputs.buildInputDecoration(
                          labelText: 'Modelo',
                        ),
                        hint: const Text("Seleccione el modelo"),
                        // Initial Value
                        value: _vehicle.model,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        items: (widget.models.isEmpty && _vehicle.model != null)
                            ? [
                                DropdownMenuItem(
                                  value: _vehicle.modelDisplay!.id,
                                  child:
                                      Text(_vehicle.modelDisplay!.description!),
                                )
                              ]
                            : widget.models.map((Model item) {
                                return DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.description!),
                                );
                              }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? value) => _vehicle.model = value,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'El modelo es obligatorio';
                          }
                          return null;
                        },
                      ),
                      FutureBuilder(
                        future: UseService.getUses({
                          'query': '{id, description}',
                          'not_paginator': true
                        }),
                        builder: (context, AsyncSnapshot<List<Use>?> snapshot) {
                          return snapshot.connectionState !=
                                  ConnectionState.done
                              ? const MyProgressIndicator()
                              : DropdownButtonFormField(
                                  decoration: CustomInputs.buildInputDecoration(
                                    labelText: 'Uso',
                                  ),
                                  hint: const Text("Seleccione el uso"),
                                  // Initial Value
                                  value: _vehicle.use,

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: snapshot.data?.map((Use item) {
                                    return DropdownMenuItem(
                                      value: item.id,
                                      child: Text(item.description!),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? value) =>
                                      _vehicle.use = value,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El uso es obligatorio';
                                    }
                                    return null;
                                  },
                                );
                        },
                      ),
                      TextFormField(
                        initialValue: _vehicle.serialBodywork ?? '',
                        onChanged: (value) => _vehicle.serialBodywork = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El serial de carrocería es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el serial de carrocería.',
                          labelText: 'Serial de carrocería',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.serialEngine ?? '',
                        onChanged: (value) => _vehicle.serialEngine = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El serial de motor es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el serial de motor.',
                          labelText: 'Serial de motor',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.stalls.toString(),
                        onChanged: (value) =>
                            _vehicle.stalls = int.parse(value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nro. de asientos es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el nro. de asientos.',
                          labelText: 'Nro. de asientos',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.color,
                        onChanged: (value) => _vehicle.color = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El color es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el color.',
                          labelText: 'Color',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.year,
                        onChanged: (value) => _vehicle.year = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El año es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el año.',
                          labelText: 'Año',
                        ),
                      ),
                      FutureBuilder(
                        future: VehicleService.fieldOptions('transmission'),
                        builder:
                            (context, AsyncSnapshot<List<Option>?> snapshot) {
                          return snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData
                              ? DropdownButtonFormField(
                                  decoration: CustomInputs.buildInputDecoration(
                                    labelText: 'Transmision',
                                  ),
                                  hint: const Text("Seleccione la transmision"),
                                  // Initial Value
                                  value: _vehicle.transmission.toString(),

                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: snapshot.data!.map((Option item) {
                                    return DropdownMenuItem(
                                      value: item.value.toString(),
                                      child: Text(item.description!),
                                    );
                                  }).toList(),
                                  onChanged: (value) => _vehicle.transmission =
                                      int.parse(value.toString()),
                                  validator: (value) {
                                    if (value == null ||
                                        value.toString().isEmpty) {
                                      return 'La transmisión es obligatoria';
                                    }
                                    return null;
                                  },
                                )
                              : const MyProgressIndicator();
                        },
                      ),
                      CustomCheckBox(
                        title: 'Activo',
                        value: _vehicle.isActive ?? true,
                        onChanged: (value) => _vehicle.isActive = value,
                      ),
                      const SizedBox(height: 30),
                      const Text('Datos del Dueño'),
                      TextFormField(
                        initialValue: _vehicle.ownerName ?? '',
                        onChanged: (value) => _vehicle.ownerName = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El nombre del dueño es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el nombre del dueño.',
                          labelText: 'Nombre del dueño',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.ownerLastName ?? '',
                        onChanged: (value) => _vehicle.ownerLastName = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El apellido del dueño es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el apellido del dueño.',
                          labelText: 'Apellido del dueño',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.ownerIdentityCard ?? '',
                        onChanged: (value) =>
                            _vehicle.ownerIdentityCard = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La cedula o el rif del dueño es obligatorio';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese la cedula o el rif del dueño.',
                          labelText: 'Cedula o Rif del dueño',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.ownerEmail ?? '',
                        onChanged: (value) => _vehicle.ownerEmail = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El correo del dueño es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el correo del dueño.',
                          labelText: 'Correo del dueño',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.ownerPhones ?? '',
                        onChanged: (value) => _vehicle.ownerPhones = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El telefono del dueño es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText: 'Ingrese el telefono correo del dueño.',
                          labelText: 'Telefono del dueño',
                        ),
                      ),
                      TextFormField(
                        initialValue: _vehicle.ownerAddress ?? '',
                        onChanged: (value) => _vehicle.ownerAddress = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Dirección del dueño es obligatoria';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) =>
                            _saveVehicle(create, vehicleProvider, _vehicle),
                        decoration: CustomInputs.buildInputDecoration(
                          hintText:
                              'Ingrese la dirección telefono correo del dueño.',
                          labelText: 'Dirección del dueño',
                        ),
                      ),
                      Wrap(
                        children: [
                          DocumentVehicle(
                            title: 'Cédula de Identidad o Rif',
                            imageUrl: _vehicle.ownerIdentityCardImage,
                            onUpload: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                // allowedExtensions: ['jpg'],
                                allowMultiple: false,
                              );

                              if (result != null) {
                                setState(() =>
                                    _vehicle.ownerIdentityCardImageFile =
                                        result.files.first);
                              } else {
                                // User canceled the picker
                              }
                            },
                          ),
                          DocumentVehicle(
                            title: 'Licencia',
                            imageUrl: _vehicle.ownerLicense,
                            onUpload: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                // allowedExtensions: ['jpg'],
                                allowMultiple: false,
                              );

                              if (result != null) {
                                setState(() => _vehicle.ownerLicenseFile =
                                    result.files.first);
                              } else {
                                // User canceled the picker
                              }
                            },
                          ),
                          DocumentVehicle(
                            title: 'Carnet de Circulación o Titulo',
                            imageUrl: _vehicle.ownerCirculationCard,
                            onUpload: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                // allowedExtensions: ['jpg'],
                                allowMultiple: false,
                              );

                              if (result != null) {
                                setState(() =>
                                    _vehicle.ownerCirculationCardFile =
                                        result.files.first);
                              } else {
                                // User canceled the picker
                              }
                            },
                            onDownload: () async {
                              final Map<String, String> headers = {
                                'Accept': '*/*',
                              };
                              var image = await vehicleProvider.dowmloadArchive(
                                  _vehicle.id!, "owner_circulation_card");

                              print(image
                                  .runtimeType); /* 
                              await FileSaver.instance.saveFile(
                                  'owner_circulation_card', image!, 'jpg'); */
                            },
                          ),
                          // DocumentVehicle(title: 'Certificado Médico'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        child: CustomButtonPrimary(
                          onPressed: () =>
                              _saveVehicle(create, vehicleProvider, _vehicle),
                          title: 'Guardar',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _saveVehicle(
    bool create,
    VehicleProvider vehicleProvider,
    Vehicle _vehicle,
  ) async {
    {
      try {
        var saved = false;
        if (create) {
          saved = await vehicleProvider.newVehicle(_vehicle) ?? false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
                '${_vehicle.licensePlate} creado');
          }
        } else {
          saved = await vehicleProvider.editVehicle(_vehicle.id!, _vehicle) ??
              false;
          if (saved) {
            NotificationService.showSnackbarSuccess(
              '${_vehicle.licensePlate} actualizado',
            );
          }
        }
        if (saved) {
          NavigationService.back(context);
        }
        return saved;
      } on ErrorAPI catch (e) {
        NotificationService.showSnackbarError(
          e.error?[0] ?? 'No se pudo guardar el vehicle',
        );
      }
    }
  }
}
