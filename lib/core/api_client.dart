import 'dart:convert';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/providers/auth_provider.dart';

class ApiClient {
  final AuthProvider authProvider;

  ApiClient(this.authProvider);

  Future<dynamic> get(BuildContext context, String url) async {
    final token = await SharedPrefs.getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 401) {
      authProvider.logout();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session expired, silakan login kembali"),
        ),
      );

      return null;
    }

    return jsonDecode(response.body);
  }
}
