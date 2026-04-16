import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/features/almawa/models/barang_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class BarangRepository {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<BarangModel>> fetchBarangs(int page) async {
    // Ambil token dari SharedPrefs
    final headers = await _headers();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/barang?page=$page'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // Handle dua kemungkinan bentuk JSON dari API
      final List data = jsonData is Map<String, dynamic>
          ? (jsonData['data'] ?? [])
          : (jsonData ?? []);

      return data.map((e) => BarangModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat barang (${response.statusCode})');
    }
  }

  Future<void> create(BarangModel item) async {
    final headers = await _headers();
    //print('📝 Menyimpan barang service: ${item.toJson()}');
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/barang'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    //print(res.body);
    //print(res.statusCode);
    if (res.statusCode != 201) {
      throw Exception('Gagal menambah barang: ${res.body}');
    }
  }

  Future<void> update(int id, BarangModel item) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/barang/$id'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    //print(res.body);
    //print(res.statusCode);
    if (res.statusCode != 200) {
      throw Exception('Gagal mengubah barang: ${res.body}');
    }
  }

  Future<void> delete(int id) async {
    final headers = await _headers();
    final res = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/barang/$id'),
      headers: headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus barang');
    }
  }
}
