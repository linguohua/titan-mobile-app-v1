import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

class VersionProvider extends ChangeNotifier {
  String _remoteVersion = '1.0.0';
  String _localVersion = '1.0.0';
  String _desc = '';
  String _url = '';
  String _cid = '';
  double _downProgress = 0.0;
  double get downProgress => _downProgress;


  String get remoteVersion => _remoteVersion;
  String get localVersion => _localVersion;
  String get url => _url;
  String get desc => _desc;
  String get cid => _cid;
  bool get isUpgradeAble => _compare(_remoteVersion, _localVersion) > 0;

  VersionProvider() {
    _loadVersionInfo();
  }

  static int _compare(String v1, v2) {
    return Version.parse(v1).compareTo(Version.parse(v2));
  }

  Future<void> _loadVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _localVersion = packageInfo.version;
    _remoteVersion = _localVersion;

    notifyListeners();
  }

  setVersion(String val, String description, String urlVal, String cid) async {
    if (val.isEmpty) {
      return;
    }

    if (val.startsWith('v') || val.startsWith('V')) {
      val = val.substring(1);
    }

    try {
      Version.parse(val);
    } on Exception {
      return;
    }

    if (_remoteVersion == val && description == _desc && _url == urlVal) {
      return;
    }

    _remoteVersion = val;
    _desc = description;
    _url = urlVal;
    _cid = cid;

    notifyListeners();
  }
  setDownProgress(double pro) {
    _downProgress = pro;
    notifyListeners();
  }
}
