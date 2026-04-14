import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nurulislam/core/navigation_service.dart';
import '../utils/shared_prefs.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedPrefs.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final message = err.response?.data['message'];
    if (err.response?.statusCode == 401) {
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Session expired. Silahkan login kembali. $message"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }

      await SharedPrefs.clear();

      Future.delayed(const Duration(seconds: 2), () {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      });
    }

    handler.next(err);
  }
}
