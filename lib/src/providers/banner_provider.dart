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
  bool loading = false;

  late GlobalKey<FormState> formBannerKey;

  String? searchValue;

  bool validateForm() {
    return formBannerKey.currentState!.validate();
  }

  Future getBanners() async {
    loading = true;
    notifyListeners();
    try {
      final response = await API.get('$url/');
      if (response.statusCode == 200) {
        ResponseData responseData = ResponseData.fromMap(response.data);
        banners = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }

  Future<BannerRCV?> getBanner(String uid) async {
    try {
      final response = await API.get('$url/$uid/');
      if (response.statusCode == 200) {
        banner = BannerRCV.fromMap(response.data);
        notifyListeners();
        return banner;
      } else {
        return null;
      }
    } on ErrorAPI {
      return null;
    }
  }

  Future<bool?> newBanner(BannerRCV bannerRCV, PlatformFile? image) async {
    if (validateForm()) {
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
          getBanners();
          // banners.add(response.data);
          // notifyListeners();
        }
        return true;
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
  }

  Future<bool?> editBanner(
      String id, BannerRCV bannerRCV, PlatformFile? image) async {
    if (validateForm()) {
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
          getBanners();
/*           banners = banners.map((_banner) {
            if (_banner['id'] == banner!.id) {
              _banner = banner!.toMap();
            }
            return _banner;
          }).toList(); */
          // notifyListeners();
        }
      } on ErrorAPI {
        rethrow;
      }
    }
    return null;
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

  Future deleteBanners(List<String> ids) async {
    try {
      final resp = await API.delete('$url/remove_multiple/', ids: ids);
      if (resp.statusCode == 200) {
        banners.removeWhere((banner) => ids.contains(banner['id'].toString()));
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on ErrorAPI {
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
        banners = responseData.results;
      }
      loading = false;
      notifyListeners();
    } on ErrorAPI {
      loading = false;
      notifyListeners();
    }
  }
}
