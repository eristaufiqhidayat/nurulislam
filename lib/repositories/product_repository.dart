import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/utils/shared_prefs.dart';
import '../core/api_client.dart';
import '../models/product_model.dart';
import '../config/api_constants.dart';

class ProductRepository {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, String>> _headersList() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<String> uploadImage(File file) async {
    final token = await SharedPrefs.getToken();
    final uri = Uri.parse('${ApiConstants.baseUrl}/api/upload-image');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    final response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      //print('Image uploaded successfully');
      final respStr = await response.stream.bytesToString();
      final jsonData = jsonDecode(respStr);
      return jsonData['filename'];
    } else {
      throw Exception('Gagal upload (${response.statusCode})');
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    final response = await ApiClient.get(
        '${ApiConstants.baseUrl}/api/products/paginate-by-user',
        headers: await _headers());

    final body = json.decode(response.body);
    final List data = body['data']['data'];

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<List<ProductModel>> fetchProductsList() async {
    final response = await ApiClient.get(
        '${ApiConstants.baseUrl}/api/productsList',
        headers: await _headersList());
    print('Response body: ${response.body}');
    final body = json.decode(response.body);
    final List data = body['data']['data'];

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> deleteProduct(int id) async {
    await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/products/$id'),
      headers: await _headers(),
    );
    print('Deleted product with id: $id');
  }

  Future<void> storeProduct(Map<String, dynamic> payload) async {
    print('Menyimpan produk dengan payload: $payload');
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/products'),
      headers: await _headers(),
      body: json.encode(payload),
    );
  }

  Future<void> updateProduct(int id, Map<String, dynamic> payload) async {
    await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/products/$id'),
      headers: await _headers(),
      body: json.encode(payload),
    );
    print("Update nih.  $payload");
  }

  Future<List<String>> uploadMultipleImages({
    List<File>? files,
    List<Uint8List>? webBytes,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConstants.baseUrl}/api/products/upload-multiple'),
    );
    final headers = await _headers();
    request.headers.addAll(headers);
    // 🌐 WEB
    if (kIsWeb && webBytes != null) {
      for (var bytes in webBytes) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'images[]',
            bytes,
            filename: 'image.jpg',
          ),
        );
      }
    }

    // 📱 MOBILE
    else if (files != null) {
      for (var file in files) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]',
            file.path,
          ),
        );
      }
    }

    var response = await request.send();
    final res = await http.Response.fromStream(response);
    print(res.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(res.body);

      // 🔥 HARUS ARRAY
      return List<String>.from(data['files']);
    } else {
      throw Exception('Upload multiple gagal ${response.statusCode}');
    }
  }
}
