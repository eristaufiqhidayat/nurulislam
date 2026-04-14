import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nurulislam/models/user_model.dart';
import 'package:nurulislam/screens/home_screen.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../../../services/auth_service.dart';

class OtpDialog extends StatefulWidget {
  final String email;
  const OtpDialog({super.key, required this.email});

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final otpCtrl = TextEditingController();
  final auth = AuthService();

  bool loading = false;
  int resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    otpCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startCountdown() {
    resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => resendSeconds--);
      }
    });
  }

  bool isValidToken(String? token) {
    if (token == null) return false;
    final t = token.trim().toLowerCase();
    if (t.isEmpty || t == 'null' || t == 'undefined') return false;
    return true;
  }

  Future<void> verify() async {
    if (otpCtrl.text.length < 6) return;

    setState(() => loading = true);
    try {
      final User user = await auth.verifyOtp(
        widget.email,
        otpCtrl.text,
      );

      if (!isValidToken(user.token)) {
        throw Exception('Invalid token');
      }

      await SharedPrefs.saveUser(user);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashBoard()),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode OTP tidak valid atau kadaluarsa'),
          backgroundColor: Colors.orange,
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> resendOtp() async {
    setState(() => loading = true);
    try {
      await auth.resendOtp(email: widget.email);
      startCountdown();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP baru berhasil dikirim'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim OTP'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔐 ICON HEADER
            Icon(
              Icons.lock_outline,
              size: 48,
              color: Colors.green.shade700,
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifikasi OTP',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 🔢 OTP FIELD
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'Masukkan Kode OTP',
                counterText: '',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ VERIFIKASI
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.verified),
                label: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Verifikasi OTP'),
                onPressed: loading ? null : verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔁 RESEND OTP
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(
                  resendSeconds > 0
                      ? 'Resend OTP (${resendSeconds}s)'
                      : 'Resend OTP',
                ),
                onPressed: (loading || resendSeconds > 0) ? null : resendOtp,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                  side: BorderSide(color: Colors.blue.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ❌ CANCEL
            TextButton.icon(
              icon: const Icon(Icons.close),
              label: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
