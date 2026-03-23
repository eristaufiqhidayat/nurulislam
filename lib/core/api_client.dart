import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiClient {
  static Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    BuildContext? context,
  }) async {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      return response;
    } else {
      return _handleError(response);
    }
  }

  static Future<dynamic> post(String url, Map data,
      {Map<String, String>? headers, BuildContext? context}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    // if (response.statusCode == 200) {
    //   print('okkk');
    //   return response;
    // } else {
    //   print('not ok ${data}');
    //   return _handleError(response);
    // }
  }

  static String? _handleError(http.Response response) {
    if (response.statusCode == 401) {
      return "Unauthorized";
    }

    if (response.statusCode >= 400) {
      return "Error ${response.statusCode}: ${response.body}";
    }
    return null;
  }

  static Future<dynamic> put(String url, Map data,
      {Map<String, String>? headers, BuildContext? context}) async {
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
    print('PUT $url - Status: ${response.statusCode} - Body: ${response.body}');

    // if (response.statusCode == 200) {
    //   return response;
    // } else {
    //   return _handleError(response);
    // }
  }

  static Future<dynamic> delete(String url,
      {Map<String, String>? headers, BuildContext? context}) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      return _handleError(response);
    }
  }
}
