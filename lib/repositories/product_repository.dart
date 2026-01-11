import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/utils/shared_prefs.dart';
import '../models/product_model.dart';
import '../config/api_constants.dart';

class ProductRepository {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/products'),
        headers: await _headers());
    print('Response code: ${response.statusCode}');
    print('Response body: ${response.body}');
    final body = json.decode(response.body);
    final List data = body['data']['data'];

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> deleteProduct(int id) async {
    await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/products/$id'),
      headers: await _headers(),
    );
  }

  Future<void> storeProduct(Map<String, dynamic> payload) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/products'),
      headers: await _headers(),
      body: json.encode(payload),
    );
  }

  Future<void> updateProduct(int id, Map<String, dynamic> payload) async {
    await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/products/$id'),
      headers: await _headers(),
      body: json.encode(payload),
    );
  }
}
