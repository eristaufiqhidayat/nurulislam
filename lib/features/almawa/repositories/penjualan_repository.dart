import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/features/almawa/models/penjualan_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

import '../../../core/api_client.dart';

class PenjualanRepository {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<PenjualanModel> create(PenjualanModel p) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/transaksi/penjualan');
    final headers = await _headers();
    print('🔗 POST $url');
    print('Payload: ${json.encode(p.toJson())}');

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
        return PenjualanModel.fromJson(data);
      } else {
        // fallback: jika server hanya kirim penjualan_id
        final id = decoded['penjualan_id'];
        if (id is int) {
          return PenjualanModel(
              id: id, pembeliId: p.pembeliId, tglTransaksi: p.tglTransaksi);
        }
        throw Exception('Response data not in expected format');
      }
    } else {
      throw Exception('Gagal membuat penjualan (code: ${res.statusCode})');
    }
  }

  Future<List<PenjualanModel>> fetchPenjualan() async {
    final headers = await _headers();

    final res = await ApiClient.get(
      '${ApiConstants.baseUrl}/api/penjualan',
      headers: headers,
    );
    //print(res.body);
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat data penjualan');
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => PenjualanModel.fromJson(e)).toList();
  }

  Future<PenjualanModel> fetchPenjualanBy(id) async {
    final headers = await _headers();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/penjualan/$id'),
      headers: headers,
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(res.body);
      return PenjualanModel.fromJson(decoded);
    } else {
      throw Exception("Gagal memuat data penjualan (${res.statusCode})");
    }
  }

  Future<bool> deletePenjualan(int id) async {
    final headers = await _headers();
    final url = Uri.parse('${ApiConstants.baseUrl}/api/penjualan/$id');

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
