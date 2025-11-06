import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../models/barang_model.dart';

class BarangService {
  Future<List<BarangModel>> fetchBarangs(int page) async {
    // Ambil token dari SharedPrefs
    final token = await SharedPrefs.getToken();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/barang?page=$page'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
    final token = await SharedPrefs.getToken();
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/barang'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: item.toJson(),
    );
    if (res.statusCode != 201) {
      throw Exception('Gagal menambah barang: ${res.body}');
    }
  }

  Future<void> update(int id, BarangModel item) async {
    final token = await SharedPrefs.getToken();
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/barang/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: item.toJson(),
    );
    if (res.statusCode != 200) {
      throw Exception('Gagal mengubah barang: ${res.body}');
    }
  }

  Future<void> delete(int id) async {
    final token = await SharedPrefs.getToken();
    final res = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/barang/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus barang');
    }
  }
}
