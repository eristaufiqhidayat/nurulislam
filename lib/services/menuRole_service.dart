import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/menuRole_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class MenuRoleService {
  final String baseUrl = ApiConstants.baseUrl; // Base URL for API
  // final String token;

  // MenuRoleService(this.token);
  // final String baseUrl =
  //     'http://localhost:8000/api/menu-roles'; // ganti sesuai server

  Future<List<MenuRole>> fetchAll() async {
    final token = await SharedPrefs.getToken();
    final response = await http
        .get(Uri.parse('$baseUrl/api/menu-roles?token=$token'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('Menu roles service ${response.body}');
    //print('$baseUrl/api/menu-roles?token=$token');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => MenuRole.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch menu_roles ${response.statusCode}');
    }
  }

  Future<void> create(MenuRole menuRole) async {
    final token = await SharedPrefs.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/menu-roles?token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(menuRole.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create');
    }
  }

  Future<void> update(int id, MenuRole menuRole) async {
    final token = await SharedPrefs.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/menu-roles/$id?token=$token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(menuRole.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update');
    }
  }

  Future<void> delete(int id) async {
    final token = await SharedPrefs.getToken();
    final response = await http
        .delete(Uri.parse('$baseUrl/api/menu-roles/$id?token=$token'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete');
    }
  }
}
