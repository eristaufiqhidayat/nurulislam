import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/repositories/penjualan_repository.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../config/api_constants.dart';
import '../models/penjualan_model.dart';
import '../models/penjualan_detil_model.dart';

class PenjualanService {
  // from api_constants.dart
  final _repo = PenjualanRepository();
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<PenjualanModel> create(PenjualanModel p) async {
    return await _repo.create(p);
  }

  Future<List<Penjualan>> fetchPenjualan() async {
    final headers = await _headers();
    final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/penjualan'),
        headers: headers);
    //print(res.body);
    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      return data.map((e) => Penjualan.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat data penjualan (${res.statusCode})");
    }
  }

  Future<PenjualanModel> fetchPenjualanBy(id) async {
    return await _repo.fetchPenjualanBy(id);
  }

  Future<bool> deletePenjualan(int id) async {
    return await _repo.deletePenjualan(id);
  }
}
