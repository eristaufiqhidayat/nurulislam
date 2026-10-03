import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/features/page_info/models/pageinfo_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class ContentRepository {
  final String category;
  ContentRepository(this.category) {
    if (!['kegiatan', 'kajian'].contains(category)) {
      throw ArgumentError.value(category, 'category');
    }
  }

  Uri get _url => Uri.parse('${ApiConstants.baseUrl}/api/$category');

  Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Silakan login kembali.');
    }
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  dynamic _decode(http.Response response) {
    dynamic data;
    try { data = jsonDecode(response.body); } catch (_) { data = null; }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (response.statusCode == 401) throw Exception('Sesi habis. Silakan login kembali.');
      if (response.statusCode == 403) throw Exception('Akun Anda tidak memiliki izin.');
      if (response.statusCode == 404) throw Exception('Data atau endpoint tidak ditemukan. Muat ulang daftar.');
      if (data is Map && data['errors'] is Map) {
        throw Exception((data['errors'] as Map).values.map((e) => e is List ? e.join('\n') : e.toString()).join('\n'));
      }
      throw Exception(data is Map ? data['message'] ?? 'Permintaan gagal (${response.statusCode}).' : 'Permintaan gagal (${response.statusCode}).');
    }
    return data;
  }

  Future<List<PageinfoModel>> list() async {
    final data = _decode(await http.get(_url, headers: await _headers()).timeout(const Duration(seconds: 30)));
    final List items = data is List ? data : data['data'] as List;
    return items.map((e) => PageinfoModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> save(PageinfoModel item) async {
    final headers = {...await _headers(), 'Content-Type': 'application/json'};
    final body = jsonEncode(item.toJson());
    final response = item.id == null
        ? await http.post(_url, headers: headers, body: body).timeout(const Duration(seconds: 30))
        : await http.put(Uri.parse('$_url/${item.id}'), headers: headers, body: body).timeout(const Duration(seconds: 30));
    _decode(response);
  }

  Future<void> delete(int id) async {
    _decode(await http.delete(Uri.parse('$_url/$id'), headers: await _headers()).timeout(const Duration(seconds: 30)));
  }

  Future<String> upload(PlatformFile file) async {
    if (file.bytes == null || file.size > 2 * 1024 * 1024) {
      throw Exception('Pilih gambar maksimal 2 MB.');
    }
    final request = http.MultipartRequest('POST', Uri.parse('${ApiConstants.baseUrl}/api/upload-image'));
    request.headers.addAll(await _headers());
    request.files.add(http.MultipartFile.fromBytes('image', file.bytes!, filename: file.name));
    final response = await http.Response.fromStream(await request.send().timeout(const Duration(seconds: 60)));
    final data = _decode(response);
    // Public cards expect the filename, rather than the complete upload URL.
    final filename = data['filename'] ?? Uri.parse(data['url'] as String).pathSegments.last;
    return filename as String;
  }
}
