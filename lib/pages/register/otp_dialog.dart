import 'package:flutter/material.dart';
import 'package:nurulislam/models/user_model.dart';
import 'package:nurulislam/screens/home_screen.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../../services/auth_service.dart';

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

  Future<void> verify() async {
    setState(() => loading = true);

    try {
      final User user = await auth.verifyOtp(
        widget.email,
        otpCtrl.text,
      );

      // 🔥 SIMPAN USER + TOKEN
      await SharedPrefs.saveUser(user);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Verifikasi OTP',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kode OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : verify,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('VERIFIKASI'),
            )
          ],
        ),
      ),
    );
  }
}
