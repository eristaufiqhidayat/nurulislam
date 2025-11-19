import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/models/supplier_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class SupplierService {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<SupplierModel>> fetch() async {
    final headers = await _headers();
    final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/supplier'),
        headers: headers);
    //print(res.body);
    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => SupplierModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data penjualan");
    }
  }

  Future<SupplierModel> fetchBy(id) async {
    final headers = await _headers();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/supplier/$id'),
      headers: headers,
    );

    print(res.body);

    if (res.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(res.body);
      return SupplierModel.fromJson(decoded);
    } else {
      throw Exception("Gagal memuat data supplier (${res.statusCode})");
    }
  }

  Future<SupplierModel> create(SupplierModel p) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/supplier');
    final headers = await _headers();

    final res = await http.post(
      url,
      headers: headers,
      body: json.encode(p.toJson()),
    );

    //print('Response code: ${res.statusCode}');
    //print('Response body: ${res.body}');

    if (res.statusCode == 201 || res.statusCode == 200) {
      final decoded = json.decode(res.body);
      final data = decoded['data'];
      if (data is Map<String, dynamic>) {
        return SupplierModel.fromJson(data);
      } else {
        // fallback: jika server hanya kirim penjualan_id
        final id = decoded['penjualan_id'];
        if (id is int) {
          return SupplierModel(
              id: id, nama: p.nama, alamat: p.alamat, telp: p.telp);
        }
        throw Exception('Response data not in expected format');
      }
    } else {
      throw Exception('Gagal membuat penjualan (code: ${res.statusCode})');
    }
  }

  Future<void> update(int id, SupplierModel item) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/supplier/$id'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    //print(res.body);
    //print(res.statusCode);
    if (res.statusCode != 200) {
      throw Exception('Gagal mengubah barang: ${res.body}');
    }
  }

  Future<bool> delete(int id) async {
    final headers = await _headers();
    final url = Uri.parse('${ApiConstants.baseUrl}/api/supplier/$id');

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
