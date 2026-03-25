import 'dart:convert';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/core/api_client.dart';
import 'package:nurulislam/models/cart_item_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
//import '../models/cart_model.dart';

// class CartService2 {
//   final String baseUrl = '${ApiConstants.baseUrl}';

//   Future<Cart> getCart() async {
//     final token = await SharedPrefs.getToken();

//     final response = await ApiClient.get(
//       '$baseUrl/cart',
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       },
//     );

//     final data = json.decode(response.body);

//     return Cart.fromJson(data['data']);
//   }
// }

class CartService {
  final String baseUrl = "${ApiConstants.baseUrl}/api";

  Future<List<CartItemModel>> getCart() async {
    final token = await SharedPrefs.getToken();

    final res = await ApiClient.get(
      '$baseUrl/cart',
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    final body = jsonDecode(res.body);

    final cart = body['data']; // ✅ Map
    if (cart == null) return [];

    final items = cart['items'] ?? []; // ✅ List

    return (items as List).map((e) => CartItemModel.fromJson(e)).toList();
  }

  Future<void> addToCart(String productId) async {
    final token = await SharedPrefs.getToken();

    await ApiClient.post(
      '$baseUrl/cart',
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      {'product_id': productId.toString()},
    );
  }

  Future<void> updateQty(int id, int qty) async {
    final token = await SharedPrefs.getToken();
    await ApiClient.put(
      "$baseUrl/cart/$id",
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      {'quantity': qty.toString()},
    );
  }

  Future<void> remove(int id) async {
    final token = await SharedPrefs.getToken();
    await ApiClient.delete(
      "$baseUrl/cart/$id",
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  Future<void> clearCart() async {
    final token = await SharedPrefs.getToken();
    await ApiClient.delete(
      "$baseUrl/cart-clear",
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }
}
