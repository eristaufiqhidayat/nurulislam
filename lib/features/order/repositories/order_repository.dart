import 'dart:convert';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

import '../../../models/order_model.dart';
import '../../../core/api_client.dart';

class OrderRepository {
  final String baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Order>> getAll() async {
    final response = await ApiClient.get(
      '$baseUrl/api/orders/my-orders',
      headers: await _headers(),
    );

    final decoded = jsonDecode(response.body);
    print(response.body);
    //final data = decoded['data'];
    final List data = decoded['data'];

    return data.map((e) => Order.fromJson(e)).toList();
  }

  Future<Order> getById(int id) async {
    final response = await ApiClient.get(
      '$baseUrl/api/orders/$id',
      headers: await _headers(),
    );

    final decoded = jsonDecode(response.body);
    return Order.fromJson(decoded['data']);
  }

  Future<void> create(Order order) async {
    await ApiClient.post(
      '$baseUrl/api/orders',
      order.toJson(),
      headers: await _headers(),
    );
  }

  Future<void> update(int id, Order order) async {
    await ApiClient.put(
      '$baseUrl/api/orders/$id',
      order.toJson(),
      headers: await _headers(),
    );
  }

  Future<void> delete(int id) async {
    await ApiClient.delete(
      '$baseUrl/api/orders/$id',
      headers: await _headers(),
    );
  }
}
