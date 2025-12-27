import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/barang_masuk_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class BarangMasukRepository {
  static const String endpoint = '${ApiConstants.baseUrl}/api/barang-masuk';
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<BarangMasukModel>> fetchAll() async {
    final headers = await _headers();
    final response = await http.get(Uri.parse(endpoint), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Bisa jadi data dikembalikan dalam bentuk {"data": [...]} atau langsung array
      final List jsonList =
          data is Map<String, dynamic> ? (data['data'] ?? []) : data;

      return jsonList.map((item) => BarangMasukModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data pembelian (${response.statusCode})');
    }
  }

  /// ✅ POST: tambah data pembelian baru
  static Future<bool> create(Map<String, dynamic> data) async {
    final headers = await _headers();
    final response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(data),
    );
    print(data);
    return response.statusCode == 201;
  }

  /// ✅ PUT: update data pembelian
  static Future<bool> update(int id, Map<String, dynamic> data) async {
    final headers = await _headers();
    final response = await http.put(
      Uri.parse('$endpoint/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    print("RESPONSE BODY ${response.body}");
    return response.statusCode == 200;
  }

  /// ✅ DELETE: hapus data pembelian
  static Future<bool> delete(int id) async {
    final headers = await _headers();
    final response = await http.delete(
      Uri.parse('$endpoint/$id'),
      headers: headers,
    );
    print(response.body);
    return response.statusCode == 200;
  }
}
