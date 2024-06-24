import 'dart:io';

import 'package:dio/dio.dart';
import 'dart:convert';

class HttpUtil {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> getRequest(String url,
      Map<String, String>? headers) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
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

  Future<Map<String, dynamic>> uploadImage(File image, String url,) async {
    String fileName = image.path
        .split('/')
        .last;

    FormData formData = FormData.fromMap({
      "file":  MultipartFile.fromFileSync(image.path, filename: fileName),
      "path": "reports"
    });
    try {
      Response response = await _dio.post(
        url,
        data: formData,
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
}
