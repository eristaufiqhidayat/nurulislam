import 'package:nurulislam/utils/shared_prefs.dart';

class ApiConstants {
  static const String baseUrl = 'https://nurul-islam.id';
  //static const String baseUrl = 'https://nurulislam.info';
  //static const String baseUrl = 'https://api.nurulislam.cloud';
  //static const String baseUrl = 'http://10.147.17.187:8011';
  //static const String baseUrl = 'http://localhost:8011';
  //static const String baseUrl = 'http://118.96.235.227:8011';
  static Future<Map<String, String>> headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
