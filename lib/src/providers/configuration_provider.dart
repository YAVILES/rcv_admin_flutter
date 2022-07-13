import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/configuration_model.dart';
import 'package:rcv_admin_flutter/src/services/notification_service.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ConfigurationProvider with ChangeNotifier {
  String url = '/system/configuration';
  late double change_factor;
  List<Configuration> configurations = [];
  bool loading = false;
  PlatformFile? _logo;

  PlatformFile? get logo => _logo;

  set logo(PlatformFile? logo) {
    _logo = logo;
    notifyListeners();
  }

  late GlobalKey<FormState> formConfigurationKey;

  bool validateForm() {
    return formConfigurationKey.currentState!.validate();
  }

  Future<List<Configuration>?> getConfigs() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response.data);
        configurations =
            data.map((conf) => Configuration.fromMap(conf)).toList();
      }
      loading = false;
      notifyListeners();
      return configurations;
    } on ErrorAPI {
      loading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool?> saveConfig(Configuration config) async {
    if (validateForm()) {
      try {
        final response =
            await API.put('$url/${config.id}/', {'value': config.value});
        if (response.statusCode == 200 || response.statusCode == 201) {
          notifyListeners();
          return true;
        }
      } on ErrorAPI {
        rethrow;
      }
    }
  }

  Future<bool?> saveMultiPle(List<Configuration> configs) async {
    if (validateForm()) {
      List<dynamic> configData = configs.map((e) {
        // if (e.key == "LOGO" && logo != null) {
        //   e.value = MultipartFile.fromBytes(
        //     logo!.bytes!,
        //     filename: logo!.name,
        //   );
        // }
        return e.toMap();
      }).toList();
      try {
        final response = await API.put('$url/update_multiple/', configData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          notifyListeners();
          NotificationService.showSnackbarSuccess('Guardado con exito');
          return true;
        }
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }
}
