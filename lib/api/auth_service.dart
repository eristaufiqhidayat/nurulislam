import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/menu_model.dart';
import 'api_constants.dart';
import '../models/pageinfo_model.dart';

class AuthService {
  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  static Future<List<MenuItem>> getUserMenu(String role) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/menu?role=$role'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) => MenuItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load menu: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading menu: $e');
    }
  }
}

class ApiService {
  Future<List<PageinfoModel>> fetchPosts(String category) async {
    final response = await http.get(
        Uri.parse("${ApiConstants.baseUrl}/api/pageinfo?category=$category"));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((item) => PageinfoModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
