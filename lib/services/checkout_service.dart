import 'dart:convert';

import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/core/api_client.dart';
import 'package:nurulislam/providers/cart_provider.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class CheckoutService {
  /// Build payload checkout
  Map<String, dynamic> buildPayload(
    CartProvider cart,
    String address,
  ) {
    final items = cart.items.map((item) {
      return {
        'product_id': item.product.id,
        'qty': item.qty,
      };
    }).toList();

    return {
      'address': address,
      'items': items,
    };
  }

  /// 🔥 METHOD YANG HILANG
  Future<void> checkout({
    required CartProvider cart,
  }) async {
    final token = await SharedPrefs.getToken();
    final response = await ApiClient.post(
        '${ApiConstants.baseUrl}/api/checkout',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token",
        },
        Map());
    //print(response.body);
    //final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      cart.clearCart();
    } else {
      throw Exception('Checkout gagal');
    }
  }
}
