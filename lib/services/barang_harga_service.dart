import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/models/detail_penjualan_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../models/barang_harga_model.dart';
import '../api/api_constants.dart'; // pastikan file ini berisi baseUrl & headers()

class BarangHargaService {
  Future<List<BarangHarga>> fetchAll() async {
    final headers = await _headers();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/barang-harga'),
      headers: headers,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body)['data'] as List;
      return data.map((e) => BarangHarga.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data harga');
    }
  }

  Future<void> create(BarangHarga item) async {
    final headers = await _headers();
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/barang-harga'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal menambah data: ${res.body}');
    }
  }

  Future<void> update(BarangHarga item) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/barang-harga/${item.id}'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memperbarui data: ${res.body}');
    }
  }

  Future<void> delete(int id) async {
    final headers = await _headers();
    final res = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/barang-harga/$id'),
      headers: headers,
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus data: ${res.body}');
    }
  }

  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<HargaResponse> getHarga({
    required int barangId,
    required String tanggal,
  }) async {
    final headers = await _headers();
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/get-harga?barang_id=$barangId&tanggal=$tanggal');

    final response = await http.get(url, headers: headers);
    //print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return HargaResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat data harga');
    }
  }
}
