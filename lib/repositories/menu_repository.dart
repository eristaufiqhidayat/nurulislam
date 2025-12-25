import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/menu_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class MenuRepository {
  static const String baseUrl = '${ApiConstants.baseUrl}/api/menus';
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

  Future<void> create(MenuModel menu) async {
    final headers = await _headers();
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(menu.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal tambah menu');
    }
  }

  Future<void> update(int id, MenuModel menu) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: jsonEncode(menu.toJson()),
    );

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
