import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    _checkError(response);
    return response;
  }

  static Future<http.Response> post(
    String url,
    Map data, {
    Map<String, String>? headers,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    _checkError(response);
    return response;
  }

  static Future<http.Response> put(
    String url,
    Map data, {
    Map<String, String>? headers,
  }) async {
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    _checkError(response);
    return response;
  }

  static Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    _checkError(response);
    return response;
  }

  /// 🔥 HANDLE ERROR DI SINI (LEBIH BERSIH)
  static void _checkError(http.Response response) {
    if (response.statusCode >= 400) {
      throw Exception(
        "Error ${response.statusCode}: ${response.body}",
      );
    }
  }
}
