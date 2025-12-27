import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/pembeli_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class PembeliRepository {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<PembeliModel>> fetchPembelis(int page) async {
    final headers = await _headers();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli?page=$page'),
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'] ?? jsonData;
      return data.map((e) => PembeliModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pembeli ${response.statusCode}');
    }
  }

  Future<void> create(PembeliModel pembeli) async {
    final headers = await _headers();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli'),
      headers: headers,
      body: json.encode(pembeli.toJson()),
    );
    print(response.body);
    if (response.statusCode != 200) throw Exception('Gagal menambah pembeli');
  }

  Future<void> update(int id, PembeliModel pembeli) async {
    final headers = await _headers();
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli/$id'),
      headers: headers,
      body: json.encode(pembeli.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Gagal mengupdate pembeli');
  }

  Future<void> delete(int id) async {
    final headers = await _headers();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli/$id'),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception('Gagal menghapus pembeli');
  }
}
