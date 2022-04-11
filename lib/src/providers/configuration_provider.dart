import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/configuration_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class ConfigurationProvider with ChangeNotifier {
  String url = '/system/configuration';
  late double change_factor;
  List<Configuration> configurations = [];
  bool loading = false;

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
}
