import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BannerRCVProvider with ChangeNotifier {
  String url = '/core/banner';
  List<Map<String, dynamic>> banners = [];

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

  Future newBanner(BannerRCV banner) async {
    final data = banner.toMap();
    try {
      final response = await API.add('$url/', data);
      if (response.statusCode == 200) {
        banners.add(response.data);
        notifyListeners();
      }
      return response;
    } on ErrorAPI catch (e) {
      print(e);
    }
  }

  Future editBanner(String id, BannerRCV data) async {
    try {
      final resp = await API.put('$url/$id/', data.toMap());
      if (resp.statusCode == 200) {
        banners = banners.map((banner) {
          if (banner['id'] != id) return banner;
          banner['title'] = data.title;
          banner['subtitle'] = data.subtitle;
          banner['content'] = data.content;
          banner['image'] = data.image;
          banner['secuence_order'] = data.sequenceOrder;
          banner['url'] = data.url;
          banner['is_active'] = data.isActive;
          return banner;
        }).toList();
        notifyListeners();
      }
    } on ErrorAPI catch (e) {
      return e;
    }
  }

  Future deleteBanner(String id) async {
    try {
      final resp = await API.delete('$url/$id/');
      if (resp.statusCode == 204) {
        banners.removeWhere((banner) => banner['id'] == id);
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
