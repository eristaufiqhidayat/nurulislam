import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/detail_penjualan_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class DetilPenjualanRepository {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static const String base =
      '${ApiConstants.baseUrl}/api'; // from api_constants.dart

  Future<HargaResponse> getHarga({
    required int barangId,
    required String tanggal,
  }) async {
    final headers = await _headers();
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/get-harga?barang_id=$barangId&tanggal=$tanggal');

    final response = await http.get(url, headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return HargaResponse.fromJson(data);
    } else {
      throw Exception('Gagal memuat data harga');
    }
  }

  Future<List<DetailPenjualan>> fetchAll() async {
    final headers = await _headers();
    final res =
        await http.get(Uri.parse('$base/detail-penjualan'), headers: headers);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => DetailPenjualan.fromJson(e)).toList();
    }
    throw Exception('Failed to load (${res.statusCode})');
  }

  Future<List<DetailPenjualan>> fetchById(int id) async {
    final headers = await _headers();
    final res = await http.get(
        Uri.parse('$base/detail-penjualan?penjualan_id=$id'),
        headers: headers);

    print("Print Load Data${res.body}");
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      print("Print Load Data Decoded$data");
      return data.map((e) => DetailPenjualan.fromJson(e)).toList();
    }
    throw Exception('Failed to load ${res.statusCode}');
  }

  Future<DetailPenjualan> create(DetailPenjualan d) async {
    final headers = await _headers();
    final res = await http.post(
      Uri.parse('$base/detail-penjualan'),
      headers: headers,
      body: json.encode(d.toJson()),
    );

    if (res.statusCode == 201) {
      return DetailPenjualan.fromJson(json.decode(res.body));
    }
    print('$base/detail-penjualan');
    print(d.toJson());
    print('Response code: ${res.statusCode}');
    print('Response body: ${res.body}');
    throw Exception('Failed to create');
  }

  Future<DetailPenjualan> update(int id, DetailPenjualan d) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('$base/detail-penjualan/$id'),
      headers: headers,
      body: json.encode(d.toJson()),
    );
    if (res.statusCode == 200) {
      return DetailPenjualan.fromJson(json.decode(res.body));
    }
    throw Exception('Failed to update');
  }

  Future<void> delete(int id) async {
    final headers = await _headers();
    final res = await http.delete(Uri.parse('$base/detail-penjualan/$id'),
        headers: headers);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete');
    }
  }
}
