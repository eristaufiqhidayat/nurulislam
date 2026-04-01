import 'package:flutter/material.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/toast_widget.dart';

class AuthHelper {
  static Future<void> handle401(
    BuildContext context, {
    String message = "Error 401: Unauthorized",
    String? statusCode,
  }) async {
    // Hapus token
    await SharedPrefs.clear();
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('Unauthorized') ||
        lowerMessage.contains('unautorized')) {
      message = "Session expired / Unauthorized";
    }
    CustomToast.show(
      context,
      message1: message,
      message2: "Silahkan Login ulang.",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 10),
      gravity: ToastGravity.center,
    );

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }

  static Future<void> sukses(
    BuildContext context, {
    String message = "Sukses",
    String? statusCode,
  }) async {
    // Hapus token
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('unauthorized') ||
        lowerMessage.contains('unautorized')) {
      message = "Session expired / Unauthorized";
    }
    CustomToast.show(
      context,
      message1: message,
      message2: "Saved successfully.",
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
      gravity: ToastGravity.center,
    );
  }
}
