import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/pageinfo_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class PageInfoRepository {
  final String pageInfoUrl = '${ApiConstants.baseUrl}/api/pageinfoCrud';
  final String uploadUrl = '${ApiConstants.baseUrl}/api/upload-image';
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> uploadImage(PlatformFile file) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('$uploadUrl?token=$token');
    final request = http.MultipartRequest('POST', uri);
    //print('$uploadUrl?token=$token');
    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes('image', file.bytes!, filename: file.name),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath('image', file.path!),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final json = jsonDecode(respStr);
      return json['url'];
    } else {
      throw Exception('Gagal upload image (status ${response.statusCode})');
    }
  }

  Future<List<PageinfoModel>> fetchPageInfos(int page) async {
    final headers = await _headers();
    final response = await http.get(
      Uri.parse('$pageInfoUrl?page=$page'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => PageinfoModel.fromJson(e)).toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<void> create(PageinfoModel item) async {
    final headers = await _headers();
    await http.post(
      Uri.parse(pageInfoUrl),
      headers: headers,
      body: item.toJson(),
    );
  }

  Future<void> update(int id, PageinfoModel item) async {
    final headers = await _headers();
    await http.put(
      Uri.parse('$pageInfoUrl/$id'),
      headers: headers,
      body: item.toJson(),
    );
  }

  Future<void> delete(int id) async {
    final headers = await _headers();
    await http.delete(
      Uri.parse('$pageInfoUrl/$id'),
      headers: headers,
    );
  }
}
