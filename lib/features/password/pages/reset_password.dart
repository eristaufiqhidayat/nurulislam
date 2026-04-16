import 'package:flutter/material.dart';
import 'package:nurulislam/core/api_client.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  final String emailOrPhone;
  final String otp;

  const ResetPasswordPage({
    super.key,
    required this.emailOrPhone,
    required this.otp,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final passwordC = TextEditingController();
  final confirmC = TextEditingController();

  bool isLoading = false;
  bool obscure1 = true;
  bool obscure2 = true;
  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> submit() async {
    final password = passwordC.text.trim();
    final confirm = confirmC.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      showMessage("Password wajib diisi");
      return;
    }

    if (password.length < 6) {
      showMessage("Minimal 6 karakter");
      return;
    }

    if (password != confirm) {
      showMessage("Password tidak sama");
      return;
    }

    setState(() => isLoading = true);

    try {
      final String baseUrl = '/api/forgot-password/reset';
      final res = await ApiClient().dio.post(
        baseUrl,
        data: {
          "email": widget.emailOrPhone,
          "otp": widget.otp,
          "password": password,
        },
      );
      if (res.statusCode == 200) {
        showMessage("OTP valid");

        // lanjut ke reset password
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        showMessage("OTP salah");
      }
    } catch (e) {
      showMessage("Error: $e");
    }

    setState(() => isLoading = false);
  }

  Widget passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: toggle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Reset Password"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Masukkan password baru", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            passwordField(
              controller: passwordC,
              label: "Password Baru",
              obscure: obscure1,
              toggle: () => setState(() => obscure1 = !obscure1),
            ),
            const SizedBox(height: 15),
            passwordField(
              controller: confirmC,
              label: "Konfirmasi Password",
              obscure: obscure2,
              toggle: () => setState(() => obscure2 = !obscure2),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
