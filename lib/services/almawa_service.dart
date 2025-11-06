import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class ApiService {
  static const String baseUrl =
      ApiConstants.baseUrl; // ubah ke IP server Laravel

  static Future<dynamic> get(String endpoint) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return _handleResponse(response);
  }

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    final token = await SharedPrefs.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(data),
    );
    print(data);
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode}, ${response.body}');
    }
  }
}
