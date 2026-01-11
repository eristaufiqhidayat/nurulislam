import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shop_model.dart';
import '../config/api_constants.dart';

class ShopRepository {
  Future<List<Map<String, dynamic>>> fetchShops({int page = 1}) async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/shops/list'),
      headers: await ApiConstants.headers(),
    );

    print(res.body);

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      final List list = jsonData['data'];
      return list.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal memuat data Category ${res.statusCode}');
    }
  }

  Future<ShopModel> saveShop(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/shops'),
      headers: await ApiConstants.headers(),
      body: jsonEncode(data),
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      return ShopModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Gagal menyimpan shop');
    }
  }

  Future<void> deleteShop(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/shops/$id'),
      headers: await ApiConstants.headers(),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus shop');
    }
  }
}
