import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/features/almawa/models/supplier_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class SupplierRepository {
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
      throw Exception("Gagal memuat data penjualan ${res.statusCode}");
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

  Future<void> create(SupplierModel item) async {
    final headers = await _headers();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/supplier'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );

    print("Response code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan supplier: ${response.body}');
    }

    // Jangan parse sebagai model, cukup selesai di sini
  }

  Future<void> update(int id, SupplierModel item) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/supplier/$id'),
      headers: headers,
      body: jsonEncode(item.toJson()),
    );
    print('Print Service supplier $id');
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
