import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/models/tabungan_qurban_detail_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../config/api_constants.dart';

class TabunganQurbanDetailRepository {
  final String baseUrl = ApiConstants.baseUrl;
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<TabunganQurbanDetailModel>> fetchPaginated({int? id}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tabungan-qurban/detail/$id'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);

      final List list = body['detail'] ?? [];

      return list.map((e) => TabunganQurbanDetailModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil detail tabungan');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/tabungan-qurban/detail/$id'),
      headers: await _headers(),
    );
    print(response.body + id.toString());
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }
}
