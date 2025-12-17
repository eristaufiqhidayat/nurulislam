import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/utils/shared_prefs.dart';
import '../models/user_model.dart';
import '../models/menu_model.dart';
import '../config/api_constants.dart';
import '../models/pageinfo_model.dart';

class AuthService {
  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/login'),
        body: {
          'email': email,
          'password': password,
        },
      );
      //print('Response status: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //print("auth_service : $data");
        return User.fromJson(data);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  static Future<List<MenuItem>> getUserMenu(String role) async {
    try {
      final token = await SharedPrefs.getToken();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/menu?token=$token&role=$role'),
        body: {
          'role': role,
          'token': token ?? '',
        },
      );
      //print(response.body);
      //print('${ApiConstants.baseUrl}/api/menu?token=$token&role=$role');
      if (response.statusCode == 200) {
        //print("Raw JSON: ${response.body}");
        final List<dynamic> data = json.decode(response.body);

        //print("Parsed JSON: $data");
        return data
            .map<MenuItem>(
                (item) => MenuItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load menu: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading menu auth_service: $e');
    }
  }

  static Future<User?> getUser() async {
    final user = await SharedPrefs.getUser();
    return user;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPrefs.getToken();
    return prefs != null;
  }

  static Future<void> logout() async {
    // ignore: unused_local_variable
    final prefs = await SharedPrefs.clear();
  }
}

class ApiService {
  Future<List<PageinfoModel>> fetchPosts(String category) async {
    final url =
        Uri.parse("${ApiConstants.baseUrl}/api/pageinfo?category=$category");
    //print(url);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((item) => PageinfoModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load posts: ${response.statusCode}");
    }
  }
}
