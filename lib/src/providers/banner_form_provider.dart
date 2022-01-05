import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BannerFormProvider with ChangeNotifier {
  String url = '/core/banner';
  BannerRCV? banner;

  late GlobalKey<FormState> formKey;

  Future<bool> saveData(BannerRCV bannerRCV, PlatformFile? image) async {
    final mapDAta = {
      if (image?.bytes != null)
        'image': MultipartFile.fromBytes(
          image!.bytes!,
          filename: image.name,
        ),
      'title': bannerRCV.title,
      'subtitle': bannerRCV.subtitle,
      'content': bannerRCV.content,
      'url': bannerRCV.url,
      'is_active': bannerRCV.isActive,
    };
    final formData = FormData.fromMap(mapDAta);
    try {
      Response resp;
      if (bannerRCV.id != null) {
        resp = await API.put('/$url/${bannerRCV.id}/', formData);
      } else {
        resp = await API.add('/$url/', formData);
      }
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        banner = BannerRCV.fromMap(resp.data);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
      rethrow;
    }
  }
}
