import 'package:flutter/material.dart';
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
      await auth.verifyOtp(widget.email, otpCtrl.text);

      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun berhasil diverifikasi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => loading = false);
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
