import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/appConfig.dart';
import '../providers/version_provider.dart';
import 'HttpUtil.dart';

class HttpService {
  final HttpUtil _networkUtil = HttpUtil();

  Future<void> checkAppVersion(
      BuildContext context, String lang, String platf) async {
    try {
      final String url = '${AppConfig.webServerURL}/api/v2/app_version';
      final headers = {'Lang': lang, 'platform': platf};
      final data = await _networkUtil.getRequest(url, headers);
      debugPrint('_getVersion：${data.toString()}');
      if (data['code'] == 0) {
        Provider.of<VersionProvider>(context, listen: false).setVersion(
          data['data']['version'],
          data['data']['description'],
          data['data']['url'],
          data['data']['cid'],
        );
      } else {
        debugPrint(
            'Failed to fetch app version. API response code: ${data['code']}');
      }
    } catch (e) {
      debugPrint('An error occurred while checking app version: $e');
    }
  }

  Future<String> discord() async {
    try {
      final String url = '${AppConfig.webServerURL}/api/v1/url/discord';
      final data = await _networkUtil.getRequest(url, null);

      if (data['code'] == 0) {
        return data['data'];
      } else {
        return AppConfig.discordURL;
      }
    } catch (e) {
      return AppConfig.discordURL;
    }
  }

  Future<Map<String, dynamic>?> banners(String lang) async {
    try {
      final String url =
          '${AppConfig.webServerURL}/api/v1/user/ads/banners?platform=2';
      final headers = {'Lang': lang};
      final data = await _networkUtil.getRequest(url, headers);
      if (data['code'] == 0) {
        return data['data'];
      }
      return null;
    } catch (e) {
      debugPrint('An error occurred while checking app version: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> notice(String lang) async {
    try {
      final String url =
          '${AppConfig.webServerURL}/api/v1/user/ads/notices?platform=2';
      final headers = {'Lang': lang};
      final data = await _networkUtil.getRequest(url, headers);
      if (data['code'] == 0) {
        return data['data'];
      }
      return null;
    } catch (e) {
      debugPrint('notice: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> bugsList(String code) async {
    try {
      final String url =
          '${AppConfig.webServerURL}/api/v1/user/bugs/list?page=1&size=10&code=$code';
      final data = await _networkUtil.getRequest(url, null);
      if (data['code'] == 0) {
        return data['data'];
      }
      return null;
    } catch (e) {
      debugPrint('bugsList: $e');
    }
    return null;
  }


  Future<Map<String, dynamic>?> uploadImage(File image,
      {Function? onProgress}) async {
    try {
      final String url = '${AppConfig.webServerURL}/api/v1/user/upload';
      final data =
          await _networkUtil.uploadImage(image, url, onProgress: onProgress);
      if (data['code'] == 0) {
        return data['data'];
      }
      return null;
    } catch (e) {
      debugPrint('notice: $e');
      return null;
    }
    return null;
  }

  Future<String?> report(Map<String, dynamic> map, String lang) async {
    try {
      final String url = '${AppConfig.webServerURL}/api/v1/user/bugs/report';
      final headers = {'Lang': lang};
      final data = await _networkUtil.postRequest(url, map, headers);
      if (data['code'] == 0) {
        return "";
      }
      return data['msg'] ?? 'error';
    } catch (e) {
      return e.toString();
    }
  }
}
