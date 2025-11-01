import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/models/menu2_model.dart';

class MenuService {
  // final String baseUrl = 'http://localhost:8000/api';
  final String baseUrl = ApiConstants.baseUrl;
  Future<List<Menu>> fetchMenus({int page = 1, int perPage = 10}) async {
    final response = await http
        .get(Uri.parse('$baseUrl/menus?page=$page&per_page=$perPage'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List menus = jsonData['data'];
      return menus.map((m) => Menu.fromJson(m)).toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<void> createMenu(Menu menu) async {
    final response = await http.post(
      Uri.parse('$baseUrl/menus'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(menu.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create menu');
    }
  }

  Future<void> updateMenu(int id, Menu menu) async {
    final response = await http.put(
      Uri.parse('$baseUrl/menus/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(menu.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update menu');
    }
  }

  Future<void> deleteMenu(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/menus/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete menu');
    }
  }
}
