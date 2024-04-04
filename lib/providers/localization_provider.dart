import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  final String key = 'locale';

  late SharedPreferences _preferences;
  late Locale _local;

  LocalizationProvider() {
    _local = LocalizationProvider.kLocalEn;
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

  _initialPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  _savePreferences() async {
    await _initialPreferences();
    _preferences.setString(key, '${_local.languageCode}_${_local.countryCode}');
  }

  _loadFromPreferences() async {
    await _initialPreferences();
    String language = _preferences.getString(key) ?? _local.languageCode;
    List<String> languages = language.split('_');
    _local = Locale(languages.first, languages.last ?? "");
    notifyListeners();
  }

  toggleChangeLocale(Locale locale) {
    _local = locale;
    print('current locale: ${_local.languageCode}_${_local.countryCode}');

    _savePreferences();
    notifyListeners();
  }
}
