import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titan_app/ffi/nativel2.dart';

class LocalizationProvider extends ChangeNotifier {
  final String key = 'locale';

  late SharedPreferences _preferences;
  late Locale _local;

  LocalizationProvider() {
    Locale deviceLocale = window.locale;
    String languageCode = deviceLocale.languageCode;
    String? countryCode = deviceLocale.countryCode;
    if (languageCode == "zh" || countryCode == "CN") {
      _local = LocalizationProvider.kLocalZh;
    } else {
      _local = LocalizationProvider.kLocalEn;
    }
    _loadFromPreferences();
  }

  String? get language => _local.languageCode;

  static Locale kLocalZh = const Locale("zh", "CN");
  static Locale kLocalEn = const Locale("en");

  Locale get locale {
    return _local;
  }

  bool isEnglish() {
    return _local.languageCode == "en";
  }

  static String localeName(String lang, context) {
    switch (lang) {
      case 'en':
        return 'English';
      case 'zh_CN':
        return '简体中文';
      default:
        return 'English';
    }
  }

  Future<void> _initialPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> _savePreferences() async {
    await _initialPreferences();
    _preferences.setString(key, '${_local.languageCode}_${_local.countryCode}');
  }

  Future<void> _loadFromPreferences() async {
    await _initialPreferences();
    String language = _preferences.getString(key) ?? _local.languageCode;
    List<String> languages = language.split('_');
    _local = Locale(languages.first, languages.last);
    notifyListeners();

    await NativeL2().setServiceLocale(_local.languageCode);
  }

  Future<void> toggleChangeLocale(Locale locale) async {
    if (locale == _local) {
      return;
    }

    _local = locale;
    debugPrint('current locale: ${_local.languageCode}_${_local.countryCode}');

    _savePreferences();
    notifyListeners();

    await NativeL2().setServiceLocale(_local.languageCode);
  }
}
