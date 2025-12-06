import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/utils/shared_prefs.dart';
import '../models/user_crud_model.dart';
import '../api/api_constants.dart';

class UserService {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<UserModel>> fetchUsers() async {
    final headers = await _headers();
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/users'),
        headers: headers);
    print(res.body);
    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      final List list = jsonData;
      return list.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data user ${res.statusCode}');
    }
  }

  Future<void> createUser(UserModel user, {String? password}) async {
    final headers = await _headers();
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/users'),
      headers: headers,
      body: json.encode(user.toJson()),
    );
    print(res.body);
    if (res.statusCode != 201) {
      throw Exception('Gagal menambah user: ${res.body}');
    }
  }

  Future<void> updateUser(UserModel user) async {
    final headers = await _headers();
    final res = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/users/${user.id}'),
      headers: headers,
      body: json.encode(user.toJson(forUpdate: true)),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal mengupdate user: ${res.body}');
    }
  }

  Future<void> deleteUser(int id) async {
    final headers = await _headers();
    final res = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/users/$id'),
      headers: headers,
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus user');
    }
  }
}
