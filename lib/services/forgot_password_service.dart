import 'package:dio/dio.dart';
import 'package:nurulislam/config/api_constants.dart';

class ForgotPasswordService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}/api', // ganti domain API
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );

  Future<void> sendOtp(String email) async {
    await dio.post('/forgot-password/otp', data: {'email': email});
  }

  Future<void> verifyOtp(String email, String otp) async {
    await dio.post('/forgot-password/verify', data: {
      'email': email,
      'otp': otp,
    });
  }

  Future<void> resetPassword(String email, String password) async {
    await dio.post('/forgot-password/reset', data: {
      'email': email,
      'password': password,
    });
  }
}
