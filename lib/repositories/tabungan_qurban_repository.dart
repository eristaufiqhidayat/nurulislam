import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/utils/shared_prefs.dart';
import '../config/api_constants.dart';

class TabunganQurbanRepository {
  final String baseUrl = ApiConstants.baseUrl;
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> fetchPaginated({int page = 1}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tabungan-qurban?page=$page'),
      headers: await _headers(),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tabungan qurban');
    }
  }

  Future<Map<String, dynamic>> fetchById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tabungan-qurban/$id'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load detail');
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tabungan-qurban'),
      headers: await _headers(),
      body: json.encode(data),
    );
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to create data');
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/tabungan-qurban/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update data');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/tabungan-qurban/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }

  Future<void> addSetoran(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tabungan-qurban/setoran'),
      headers: await _headers(),
      body: json.encode(data),
    );
    print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Failed to add setoran');
    }
  }
}
