import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../models/barang_masuk_model.dart';
import '../utils/shared_prefs.dart';

class BarangMasukService {
  static const String endpoint = '${ApiConstants.baseUrl}/api/barang-masuk';

  /// Ambil header dengan Authorization token
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// ✅ GET: semua data pembelian (barang masuk)
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

    print('📦 [POST] $endpoint');
    print('➡️ Request: ${jsonEncode(data)}');
    print('➡️ Response: ${response.statusCode}');
    print('➡️ Body: ${response.body}');

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

    print('📦 [PUT] $endpoint/$id');
    print('➡️ Request: ${jsonEncode(data)}');
    print('➡️ Response: ${response.statusCode}');
    print('➡️ Body: ${response.body}');

    return response.statusCode == 200;
  }

  /// ✅ DELETE: hapus data pembelian
  static Future<bool> delete(int id) async {
    final headers = await _headers();
    final response = await http.delete(
      Uri.parse('$endpoint/$id'),
      headers: headers,
    );

    print('📦 [DELETE] $endpoint/$id');
    print('➡️ Response: ${response.statusCode}');
    print('➡️ Body: ${response.body}');

    return response.statusCode == 200;
  }
}
