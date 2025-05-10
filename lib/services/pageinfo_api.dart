import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pageinfo_model.dart';

class ApiService {
  final String baseUrl = "http://localhost:8000";

  Future<List<PageinfoModel>> fetchPosts(String category) async {
    final response =
        await http.get(Uri.parse("$baseUrl/api/pageinfo?category=$category"));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((item) => PageinfoModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
