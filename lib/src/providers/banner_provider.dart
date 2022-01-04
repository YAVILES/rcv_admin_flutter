import 'package:flutter/material.dart';
import 'package:rcv_admin_flutter/src/models/banner_model.dart';
import 'package:rcv_admin_flutter/src/models/response_list.dart';
import 'package:rcv_admin_flutter/src/utils/api.dart';

class BannerRCVProvider with ChangeNotifier {
  List<Map<String, dynamic>> banners = [];

  Future getBanners() async {
    final response = await API.list('/core/banner/');
    ResponseData responseData = ResponseData.fromMap(response);
    banners = responseData.results;
    notifyListeners();
  }

  Future newBanner(BannerRCV banner) async {
    final data = banner.toMap();
    try {
      final response = await API.add('/core/banner/', data);
      banners.add(response);
      notifyListeners();
    } catch (e) {
      throw 'Error al crear banner';
    }
  }

  Future editBanner(String id, BannerRCV data) async {
    try {
      await API.put('/core/banner/$id/', data.toMap());
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
    } catch (e) {
      throw 'Error al editar banner';
    }
  }

  Future deleteBanner(String id) async {
    try {
      await API.delete('/core/banner/$id/');
      banners.removeWhere((banner) => banner['id'] == id);
      notifyListeners();
    } catch (e) {
      throw 'No se pudo eliminar el banner';
    }
  }

  void sort<T>(Comparable<T> Function(Map<String, dynamic> banner) getField) {
    banners.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);

      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }
}
