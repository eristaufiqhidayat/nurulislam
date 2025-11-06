import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';

class ApiService {
  static const String baseUrl = ApiConstants.baseUrl; // Ganti sesuai IP server

  static Future<List<dynamic>> getBarang() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data barang');
    }
  }

  static Future<void> deleteBarang(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus data');
    }
  }

  static Future<void> addBarang(Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(baseUrl), body: data);
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Gagal menambahkan data');
    }
  }

  static Future<void> updateBarang(int id, Map<String, dynamic> data) async {
    final response = await http.put(Uri.parse('$baseUrl/$id'), body: data);
    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui data');
    }
  }
}
