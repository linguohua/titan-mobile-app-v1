import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class HttpUtil {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getRequest(
      String url, Map<String, String>? headers) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      debugPrint(
          'request<<<<<<<<<<<<<<<<<<<<<<<<<<<<：\n${url} :options=${headers} \n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n');

      debugPrint(
          'response<<<<<<<<<<<<<<<<<<<<<<<<<<<<：\n${response.data} \n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      if (response.statusCode == 200) {
        return jsonDecode(response.toString());
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while making GET request: $e');
    }
  }

  Future<Map<String, dynamic>> uploadImage(File image, String url,
      {Function? onProgress}) async {
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromFileSync(image.path, filename: fileName),
      "path": "reports"
    });
    try {
      Response response = await _dio.post(
        url,
        data: formData,
        onSendProgress: (int sent, int total) {
          double progress = (sent / total);
          onProgress?.call(progress);
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.toString());
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while making GET request: $e');
    }
  }

  Future<Map<String, dynamic>> postRequest(String url,
      Map<String, dynamic> data, Map<String, String>? headers) async {
    try {

      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
      debugPrint(
          'request<<<<<<<<<<<<<<<<<<<<<<<<<<<<：\n${url} :options=${headers} \n >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n');

      debugPrint(
          'response<<<<<<<<<<<<<<<<<<<<<<<<<<<<：\n${response.data} \n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.toString());
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred while making POST request: $e');
    }
  }
}
