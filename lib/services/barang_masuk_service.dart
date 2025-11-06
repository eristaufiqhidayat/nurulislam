import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../models/barang_masuk_model.dart';

class BarangMasukService {
  final String token;
  BarangMasukService(this.token);

  Future<void> create(BarangMasukModel item) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/transaksi/barang-masuk'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(item.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Gagal menyimpan data barang masuk');
    }
  }
}
