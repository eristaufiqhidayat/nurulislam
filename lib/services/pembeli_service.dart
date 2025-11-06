import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../models/pembeli_model.dart';

class PembeliService {
  final String token;
  PembeliService(this.token);

  Future<List<PembeliModel>> fetchPembelis(int page) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli?page=$page'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'] ?? jsonData;
      return data.map((e) => PembeliModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data pembeli');
    }
  }

  Future<void> create(PembeliModel pembeli) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode(pembeli.toJson()),
    );
    print(response.body);
    if (response.statusCode != 201) throw Exception('Gagal menambah pembeli');
  }

  Future<void> update(int id, PembeliModel pembeli) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: json.encode(pembeli.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Gagal mengupdate pembeli');
  }

  Future<void> delete(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) throw Exception('Gagal menghapus pembeli');
  }
}
