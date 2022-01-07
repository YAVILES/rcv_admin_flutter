import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BannerRCVProvider with ChangeNotifier {
  String url = '/core/banner';
  List<Map<String, dynamic>> banners = [];
  BannerRCV? banner;

  late GlobalKey<FormState> formKey;

  Future getBanners() async {
    try {
      final response = await API.list('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        banners = responseData.results;
        notifyListeners();
      }
    } on ErrorAPI catch (e) {
      print(e);
    }
  }

  Future<BannerRCV?> getBanner(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        return BannerRCV.fromMap(response.data);
      } else {
        return null;
      }
    } on ErrorAPI catch (e) {
      return null;
    }
  }

  Future newBanner(BannerRCV bannerRCV, PlatformFile? image) async {
    final mapDAta = {
      if (image?.bytes != null)
        'image': MultipartFile.fromBytes(
          image!.bytes!,
          filename: image.name,
        ),
      ...bannerRCV.toMap(excludeImage: true),
    };
    final formData = FormData.fromMap(mapDAta);
    try {
      final response = await API.add('$url/', formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        banner = BannerRCV.fromMap(response.data);
        banners.add(response.data);
        notifyListeners();
      }
      return response;
    } on ErrorAPI {
      rethrow;
    }
  }

  Future editBanner(String id, BannerRCV bannerRCV, PlatformFile? image) async {
    final mapDAta = {
      if (image?.bytes != null)
        'image': MultipartFile.fromBytes(
          image!.bytes!,
          filename: image.name,
        ),
      ...bannerRCV.toMap(excludeImage: true),
    };
    final formData = FormData.fromMap(mapDAta);

    try {
      final response = await API.put('$url/$id/', formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        banner = BannerRCV.fromMap(response.data);
        banners = banners.map((_banner) {
          if (_banner['id'] == banner!.id) {
            _banner = banner!.toMap();
          }
          return _banner;
        }).toList();
        notifyListeners();
      }
    } on ErrorAPI {
      rethrow;
    }
  }

  Future deleteBanner(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        banners
            .removeWhere((banner) => banner['id'].toString() == id.toString());
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
