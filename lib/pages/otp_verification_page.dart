import 'package:flutter/material.dart';
import 'package:nurulislam/services/forgot_password_service.dart';
import 'change_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final otpCtrl = TextEditingController();
  final service = ForgotPasswordService();

  bool loading = false;

  Future<void> verifyOtp() async {
    if (otpCtrl.text.length != 6) {
      show('OTP harus 6 digit');
      return;
    }

    setState(() => loading = true);
    try {
      await service.verifyOtp(widget.email, otpCtrl.text);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChangePasswordPage(email: widget.email),
        ),
      );
    } catch (_) {
      show('OTP tidak valid atau kadaluarsa');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange),
    );
  }

  @override
  void dispose() {
    otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.sms_outlined,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            Text(
              'Kode OTP telah dikirim ke\n${widget.email}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'Kode OTP',
                counterText: '',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.verified),
                label: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verifikasi OTP'),
                onPressed: loading ? null : verifyOtp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
