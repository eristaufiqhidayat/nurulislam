import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/features/menus/models/menu_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class MenuRepository {
  static const String baseUrl = '${ApiConstants.baseUrl}/api/menus';
  final String uploadUrl = '${ApiConstants.baseUrl}/api/upload-image';
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<MenuModel>> fetchMenus() async {
    final headers = await _headers();
    final res = await http.get(Uri.parse(baseUrl), headers: headers);
    //print(res.body);
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => MenuModel.fromJson(e)).toList();
    }
    throw Exception('Gagal load menu');
  }

  Future<void> create(MenuModel menu, File? icon) async {
    final token = await SharedPrefs.getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl),
    );

    // ✅ HEADERS
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // ✅ TEXT FIELDS
    request.fields.addAll({
      'title': menu.title,
      'route': menu.route ?? '',
      'order': menu.order.toString(),
    });

    // ✅ FILE (INI YANG PENTING)
    if (icon != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'icon', // ⬅️ HARUS sama dengan name di Laravel
          icon.path,
        ),
      );
    }
    print('REQUEST URL: ${request.url}');
    print('HEADERS: ${request.headers}');
    print('FIELDS: ${request.fields}');
    print('FILES: ${request.files.length}');

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print('STATUS: ${response.statusCode}');
    print('BODY: $body');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal simpan menu');
    }
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

  Future<void> update(int id, MenuModel menu) async {
    final headers = await _headers();
    print('Updating menu id $id with data: ${menu.toJson()}');
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: jsonEncode(menu.toJson()),
    );
    print(res.body);
    if (res.statusCode != 200) {
      throw Exception('Gagal update menu');
    }
  }

  Future<void> delete(int id) async {
    final headers = await _headers();
    final res = await http.delete(Uri.parse('$baseUrl/$id'), headers: headers);
    if (res.statusCode != 200) {
      throw Exception('Gagal hapus menu');
    }
  }
}
