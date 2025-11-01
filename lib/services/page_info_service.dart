import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import '../models/pageinfo_model.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import '../models/pageinfo_model.dart';

class PageInfoService {
  final String token;
  final String pageInfoUrl = '${ApiConstants.baseUrl}/api/pageinfoCrud';
  final String uploadUrl = '${ApiConstants.baseUrl}/api/upload-image';
  final String baseUrl = '${ApiConstants.baseUrl}/api/pageinfoCrud';
  PageInfoService(this.token);

  Future<String> uploadImage(PlatformFile file) async {
    final uri = Uri.parse('$uploadUrl?token=$token');
    final request = http.MultipartRequest('POST', uri);
    print('$uploadUrl?token=$token');
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
    final response = await http.get(
      Uri.parse('$pageInfoUrl?page=$page'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => PageinfoModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> create(PageinfoModel item) async {
    await http.post(
      Uri.parse(pageInfoUrl),
      headers: {'Authorization': 'Bearer $token'},
      body: item.toJson(),
    );
  }

  Future<void> update(int id, PageinfoModel item) async {
    await http.put(
      Uri.parse('$pageInfoUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
      body: item.toJson(),
    );
  }

  Future<void> delete(int id) async {
    await http.delete(
      Uri.parse('$pageInfoUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
