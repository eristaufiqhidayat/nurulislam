import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/role_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class RoleRepository {
  final String baseUrl = '${ApiConstants.baseUrl}/api/roles';
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<RoleModel>> getRoles() async {
    final headers = await _headers();
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/role'),
        headers: headers);

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);

      return data.map((e) => RoleModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "Gagal load role: status=${res.statusCode}, body=${res.body}");
    }
  }

  Future<List<RoleModel>> fetchRoles() async {
    final headers = await _headers();
    final res = await http.get(Uri.parse(baseUrl), headers: headers);
    //print(res.body);
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);

      // 🔥 PENTING: ambil 'data'
      final List list = decoded['data'];

      return list.map((e) => RoleModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal load roles');
    }
  }

  Future<void> createRole(RoleModel role) async {
    final headers = await _headers();
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(role.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal tambah role');
    }
  }

  Future<void> updateRole(RoleModel role) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('$baseUrl/${role.id}'),
      headers: headers,
      body: jsonEncode(role.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal update role');
    }
  }

  Future<void> deleteRole(int id) async {
    final headers = await _headers();
    final res = await http.delete(Uri.parse('$baseUrl/$id'), headers: headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal hapus role');
    }
  }
}
