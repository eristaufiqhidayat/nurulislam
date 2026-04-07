import 'package:nurulislam/utils/shared_prefs.dart';

class ApiConstants {
  //static const String baseUrl = 'https://nurul-islam.id';
  static const String baseUrl = 'http://localhost:8013';
  static Future<Map<String, String>> headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static String getFullImageUrl(String path) {
    if (path.startsWith('http')) {
      // paksa jadi https
      return path.replaceFirst('http://', 'https://');
    }
    return '$baseUrl/$path';
  }
}
