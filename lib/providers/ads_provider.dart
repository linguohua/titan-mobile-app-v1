import 'package:flutter/material.dart';

class AdsProvider extends ChangeNotifier {
  List<dynamic> _banners = [];

  List<dynamic> get banners => _banners;

  List<dynamic>? _notices = [];

  List<dynamic>? get notices => _notices;

  setBanners(List<dynamic> list) {
    _banners = list;
    notifyListeners();
  }

  setNotices(List<dynamic>? list) {
    _notices = list;
    notifyListeners();
  }
}
