import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_constants.dart';

class CheckoutRepository {
  Future<Map<String, dynamic>> checkout(
      List<Map<String, dynamic>> items) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/checkout'),
      headers: await ApiConstants.headers(),
      body: jsonEncode({
        'items': items,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Checkout gagal');
    }

    return jsonDecode(response.body);
  }
}
