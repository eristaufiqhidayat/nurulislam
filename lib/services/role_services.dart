import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../models/role_model.dart';

class RoleService {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<RoleModel>> getRoles() async {
    final headers = await _headers();
    final res = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/role'),
        headers: headers);

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);

      return data.map((e) => RoleModel.fromJson(e)).toList();
    } else {
      throw Exception(
          "Gagal load role: status=${res.statusCode}, body=${res.body}");
    }
  }
}
