import 'package:flutter/material.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/toast_widget.dart';

class AuthHelper {
  static Future<void> handle401(
    BuildContext context, {
    String message = "Sesi Anda telah berakhir. Silakan login kembali.",
  }) async {
    // Hapus token
    await SharedPrefs.clear();

    CustomToast.show(
      context,
      message1: message,
      message2: "Silahkan Login ulang.",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),
      gravity: ToastGravity.center,
    );

    // if (context.mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //         content: Text("Sesi Anda telah berakhir. Silakan login kembali.")),
    //   );
    // }
    // Redirect ke login (hapus semua halaman sebelumnya)
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    }
  }
}
