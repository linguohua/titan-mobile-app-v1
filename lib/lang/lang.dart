import 'package:flutter/material.dart';
import 'package:titan_app/lang/lang_ch.dart';
import 'package:titan_app/lang/lang_dict.dart';
import 'package:titan_app/lang/lang_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLanguagePreference(int languageCode) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.setInt('languageCode', languageCode);
}

Future<int> getLanguagePreference() async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getInt('languageCode') ?? 1;
}

class Lang {
  // singleton pattern
  static final Lang _instance = Lang._internal();
  final _dicts = [LangDictCH(), LangDictEN()];
  int _index = 1;
  VoidCallback? onLangChanged;

  Lang._internal() {
    loadLangIndex();
  }

  factory Lang() {
    return _instance;
  }

  LangDict get dict => _dicts[_index];

  void loadLangIndex() async {
    var i = await getLanguagePreference();
    forceLangIndex(i);
  }

  void forceLangIndex(int i) {
    if (i >= _dicts.length) {
      i = 0;
    }

    if (_index != i) {
      _index = i;
      saveLanguagePreference(i);
      onLangChanged?.call();
    }
  }

  List<String> allLang() {
    List<String> langs = [];
    for (var l in _dicts) {
      langs.add(l.lang);
    }

    return langs;
  }

  int get current => _index;
}
