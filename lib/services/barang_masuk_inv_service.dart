import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/models/barang_masuk_inv_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class BarangMasukInvService {
  String route = 'barang-masuk-inv';
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<BarangMasukInvModel>> fetch() async {
    final headers = await _headers();
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/$route'),
        headers: headers);
    print(res.body);
    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      final data = (jsonData['data'] ?? jsonData) as List;
      return data.map((e) => BarangMasukInvModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data penjualan");
    }
  }

  Future<BarangMasukInvModel> fetchBy(id) async {
    final headers = await _headers();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/$route/$id'),
      headers: headers,
    );

    print(res.body);

    if (res.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(res.body);
      return BarangMasukInvModel.fromJson(decoded);
    } else {
      throw Exception("Gagal memuat data supplier (${res.statusCode})");
    }
  }

  Future<BarangMasukInvModel> create(BarangMasukInvModel p) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/$route');
    final headers = await _headers();

    final res = await http.post(
      url,
      headers: headers,
      body: json.encode(p.toJson()),
    );

    print('Response code: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 201 || res.statusCode == 200) {
      final decoded = json.decode(res.body);
      final data = decoded['data'];
      if (data is Map<String, dynamic>) {
        return BarangMasukInvModel.fromJson(data);
      } else {
        // fallback: jika server hanya kirim penjualan_id
        final id = decoded['penjualan_id'];
        if (id is int) {
          return BarangMasukInvModel(
              id: id, idSupplier: p.idSupplier, tanggal: p.tanggal);
        }
        throw Exception('Response data not in expected format');
      }
    } else {
      throw Exception('Gagal membuat penjualan (code: ${res.statusCode})');
    }
  }

  Future<void> update(int id, BarangMasukInvModel item) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/$route/$id'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    print('Print Service supplier ${id}');
    //print(res.statusCode);
    if (res.statusCode != 200) {
      throw Exception('Gagal mengubah barang: ${res.body}');
    }
  }

  Future<bool> delete(int id) async {
    final headers = await _headers();
    final url = Uri.parse('${ApiConstants.baseUrl}/api/$route/$id');

    //print('🔹 Menghapus penjualan ID: $id');
    final res = await http.delete(url, headers: headers);

    //print('🔹 Status Code: ${res.statusCode}');
    //print('🔹 Body: ${res.body}');

    if (res.statusCode == 200) {
      // Berhasil hapus
      return true;
    } else {
      // Gagal hapus
      final message = jsonDecode(res.body)['message'] ?? 'Gagal menghapus data';
      throw Exception(message);
    }
  }
}
