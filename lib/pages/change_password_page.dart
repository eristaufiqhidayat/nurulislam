import 'package:flutter/material.dart';
import 'package:nurulislam/services/forgot_password_service.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;

  const ChangePasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final service = ForgotPasswordService();

  bool loading = false;
  bool obscure1 = true;
  bool obscure2 = true;

  Future<void> submit() async {
    if (passwordCtrl.text.length < 6) {
      show('Password minimal 6 karakter');
      return;
    }

    if (passwordCtrl.text != confirmCtrl.text) {
      show('Konfirmasi password tidak sama');
      return;
    }

    setState(() => loading = true);
    try {
      await service.resetPassword(
        widget.email,
        passwordCtrl.text,
      );

      if (!mounted) return;
      show('Password berhasil diubah', success: true);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.popUntil(context, (r) => r.isFirst);
      });
    } catch (_) {
      show('Gagal mengubah password');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void show(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Password Baru')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.lock_reset,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordCtrl,
              obscureText: obscure1,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure1 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => obscure1 = !obscure1),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmCtrl,
              obscureText: obscure2,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => obscure2 = !obscure2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Simpan Password'),
                onPressed: loading ? null : submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
