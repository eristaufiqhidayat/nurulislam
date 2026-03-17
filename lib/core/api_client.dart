import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/core/SnackBarService.dart';

class ApiClient {
  static Future<http.Response> get(String url,
      {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    print("dari service: ${response.statusCode}");
    _handleError(response);

    return response;
  }

  static Future<http.Response> post(String url, Map data,
      {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    _handleError(response);

    return response;
  }

  static void _handleError(http.Response response) {
    if (response.statusCode == 401) {
      SnackBarService.show("Session expired, silakan login kembali");

      throw Exception("401 Unauthorized");
    }
    if (response.statusCode == 200) {
      SnackBarService.show("suksesssss ");
    }
    if (response.statusCode >= 400) {
      throw Exception("HTTP Error ${response.statusCode}");
    }
  }
}
