import 'package:flutter/material.dart';
import 'package:nurulislam/core/api_client.dart';
import 'package:nurulislam/features/password/pages/otp_lupa_password.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> sendReset() async {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      showMessage("Email wajib diisi");
      return;
    }
    setState(() => isLoading = true);

    try {
      final String baseUrl = '/api/forgot-password/otp';
      final res = await ApiClient().dio.post(baseUrl, data: {"email": input});

      if (res.statusCode == 200) {
        showMessage(res.data['message'] ?? "OTP terkirim");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OtpPage(emailOrPhone: input)),
        );
      } else {
        showMessage(res.data['message'] ?? "Gagal mengirim OTP");
      }
    } catch (e) {
      showMessage("Terjadi error: $e");
    }

    setState(() => isLoading = false);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Lupa Password"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Masukkan email untuk reset password",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendReset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Reset"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
