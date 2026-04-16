import 'dart:convert';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

import '../../../models/shop_model.dart';
import '../../../core/api_client.dart';

class ShopRepository {
  final String baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Shop>> getAll() async {
    final response = await ApiClient.get(
      '$baseUrl/api/shops',
      headers: await _headers(),
    );

    final decoded = jsonDecode(response.body);

    //final data = decoded['data'];
    final List data = decoded['data']['data'];

    return data.map((e) => Shop.fromJson(e)).toList();
  }

  Future<Shop> getById(int id) async {
    final response = await ApiClient.get(
      '$baseUrl/api/shops/$id',
      headers: await _headers(),
    );

    final decoded = jsonDecode(response.body);
    return Shop.fromJson(decoded['data']);
  }

  Future<void> create(Shop shop) async {
    await ApiClient.post(
      '$baseUrl/api/shops',
      shop.toJson(),
      headers: await _headers(),
    );
  }

  Future<void> update(int id, Shop shop) async {
    await ApiClient.put(
      '$baseUrl/api/shops/$id',
      shop.toJson(),
      headers: await _headers(),
    );
  }

  Future<void> delete(int id) async {
    await ApiClient.delete(
      '$baseUrl/api/shops/$id',
      headers: await _headers(),
    );
  }
}
