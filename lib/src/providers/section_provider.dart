import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/option_model.dart';
import 'package:rcv_admin_flutter/src/models/section_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class SectionProvider with ChangeNotifier {
  String url = '/core/section';
  List<Map<String, dynamic>> sections = [];
  Section? section;
  List<Map<String, dynamic>> _selecteds = [];

  List<Map<String, dynamic>> get selecteds => _selecteds;

  set selecteds(List<Map<String, dynamic>> selecteds) {
    _selecteds = selecteds;
    notifyListeners();
  }

  bool loading = false;
  Option? type;
  late GlobalKey<FormState> formSectionKey;

  String? searchValue;

  bool validateForm() {
    return formSectionKey.currentState!.validate();
  }

  setType(Option? _type) {
    type = _type;
    section!.type = _type?.value;
    notifyListeners();
  }

  Future getSections() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.get('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        sections = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }

  Future<Section?> getSection(String uid) async {
    section = null;
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        section = Section.fromMap(response.data);
        type = Option(value: section!.type, description: section!.typeDisplay);
        notifyListeners();
        return section;
      } else {
        notifyListeners();
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newSection(Section sectionRCV, PlatformFile? image,
      PlatformFile? shape, PlatformFile? icon) async {
    if (validateForm()) {
      final mapDAta = {
        if (image?.bytes != null)
          'image': MultipartFile.fromBytes(
            image!.bytes!,
            filename: image.name,
          ),
        if (shape?.bytes != null)
          'shape': MultipartFile.fromBytes(
            shape!.bytes!,
            filename: shape.name,
          ),
        if (icon?.bytes != null)
          'icon': MultipartFile.fromBytes(
            icon!.bytes!,
            filename: icon.name,
          ),
        ...sectionRCV.toMap()
      };
      final formData = FormData.fromMap(mapDAta);
      try {
        final response = await API.add('$url/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          section = Section.fromMap(response.data);
          type = null;
          getSections();
          // sections.add(response.data);
          // notifyListeners();
        }
        return true;
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }

  Future<bool?> editSection(String id, Section sectionRCV, PlatformFile? image,
      PlatformFile? shape, PlatformFile? icon) async {
    if (validateForm()) {
      final mapDAta = {
        if (image?.bytes != null)
          'image': MultipartFile.fromBytes(
            image!.bytes!,
            filename: image.name,
          ),
        if (shape?.bytes != null)
          'shape': MultipartFile.fromBytes(
            shape!.bytes!,
            filename: shape.name,
          ),
        if (icon?.bytes != null)
          'icon': MultipartFile.fromBytes(
            icon!.bytes!,
            filename: icon.name,
          ),
        ...sectionRCV.toMap()
      };
      final formData = FormData.fromMap(mapDAta);

      try {
        final response = await API.put('$url/$id/', formData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          section = Section.fromMap(response.data);
          type = null;
          getSections();
/*           sections = sections.map((_section) {
            if (_section['id'] == section!.id) {
              _section = section!.toMap();
            }
            return _section;
          }).toList(); */
          // notifyListeners();
          return true;
        }
        return false;
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }

  Future deleteSection(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        sections.removeWhere(
            (section) => section['id'].toString() == id.toString());
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteSections(List<String> ids) async {
    loading = true;
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        sections
            .removeWhere((section) => ids.contains(section['id'].toString()));
        loading = false;
        notifyListeners();
        return true;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } on ErrorAPI {
      loading = false;
      notifyListeners();
      rethrow;
    }
  }

  search(value) async {
    searchValue = value;
    loading = true;
    notifyListeners();
    try {
      final response = await API.get('$url/', params: {"search": value});
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        sections = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }
}
