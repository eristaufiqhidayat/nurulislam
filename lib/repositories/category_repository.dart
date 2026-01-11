import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../config/api_constants.dart';

class CategoryRepository {
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/categories/list'),
      headers: await ApiConstants.headers(),
    );
    print(res.body);

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      final List list = jsonData['data'];
      return list.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal memuat data Category ${res.statusCode}');
    }
  }

  Future<List<CategoryModel>> fetchAll() async {
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/categories'),
      headers: await ApiConstants.headers(),
    );

    final body = json.decode(res.body);
    final List data = body['data']['data'];

    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<void> save(Map<String, dynamic> payload) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/categories/save'),
      headers: await ApiConstants.headers(),
      body: json.encode(payload),
    );
  }

  Future<void> delete(int id) async {
    await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/categories/$id'),
      headers: await ApiConstants.headers(),
    );
  }
}
