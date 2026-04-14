import 'package:flutter/material.dart';
import 'package:nurulislam/core/api_client.dart';
import 'package:nurulislam/features/password/pages/reset_password.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class OtpPage extends StatefulWidget {
  final String emailOrPhone;

  const OtpPage({super.key, required this.emailOrPhone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  String get otp => controllers.map((c) => c.text).join();

  void onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    if (otp.length != 6) {
      showMessage("OTP harus 6 digit");
      return;
    }

    setState(() => isLoading = true);

    try {
      final String baseUrl = '/api/forgot-password/verify';
      final res = await ApiClient().dio.post(
        baseUrl,
        data: {"email": widget.emailOrPhone, "otp": otp},
      );
      print("OTP VERIFY RESPONSE: ${res.data}");
      if (res.statusCode == 200) {
        showMessage("OTP valid");

        // lanjut ke reset password
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ResetPasswordPage(emailOrPhone: widget.emailOrPhone, otp: otp),
          ),
        );
      } else {
        showMessage("OTP salah");
      }
    } catch (e) {
      showMessage("OTP tidak valid");
    }

    setState(() => isLoading = false);
  }

  Future<void> resendOtp() async {
    try {
      final String baseUrl = '/api/forgot-password/otp';
      final res = await ApiClient().dio.post(
        baseUrl,
        data: {"email": widget.emailOrPhone},
      );
      if (res.statusCode == 200) {
        showMessage(res.data['message'] ?? "OTP dikirim ulang");
      } else {
        showMessage(res.data['message'] ?? "Gagal mengirim ulang OTP");
      }

      showMessage("OTP dikirim ulang");
    } catch (e) {
      showMessage("Gagal resend OTP");
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget otpBox(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => onChanged(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Verifikasi OTP"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Masukkan kode OTP yang dikirim ke\n${widget.emailOrPhone}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, otpBox),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verifikasi"),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: resendOtp,
              child: const Text("Kirim ulang OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
