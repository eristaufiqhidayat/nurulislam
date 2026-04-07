import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../services/auth_service.dart';
import 'otp_dialog.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final nohp = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  String role = 'jamaah';
  bool loading = false;
  String selectedCode = '+62'; // default Indonesia

  final List<Map<String, String>> countryCodes = [
    {'code': '+62', 'country': 'Indonesia'},
    {'code': '+1', 'country': 'USA'},
    {'code': '+60', 'country': 'Malaysia'},
    {'code': '+65', 'country': 'Singapore'},
  ];
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    String cleanNumber =
        nohp.text.startsWith('0') ? nohp.text.substring(1) : nohp.text;

    setState(() => loading = true);

    try {
      await _auth.register(
        name: nameCtrl.text,
        email: emailCtrl.text,
        password: passCtrl.text,
        role: 'jamaah',
        nohp: '$selectedCode$cleanNumber',
      );

      if (!mounted) return;

      // ✅ HANYA muncul kalau sukses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => OtpDialog(email: emailCtrl.text),
      );
    } catch (e) {
      // ✅ hanya error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => loading = false); // ✅ ini saja di finally
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Register Baru'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Daftar Akun',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 16),
              _input(nameCtrl, 'Nama'),
              const SizedBox(height: 12),
              _input(emailCtrl, 'Email'),
              const SizedBox(height: 12),
              _phoneInput(),
              const SizedBox(height: 12),
              _input(passCtrl, 'Password', obscure: true),
              const SizedBox(height: 12),
              _confirmPasswordInput(),
              const SizedBox(height: 12),
              // DropdownButtonFormField(
              //   value: role,
              //   items: const [
              //     DropdownMenuItem(value: 'jamaah', child: Text('Jamaah')),
              //     DropdownMenuItem(value: 'panitia', child: Text('Panitia')),
              //   ],
              //   onChanged: (v) => setState(() => role = v!),
              //   decoration: _decoration('Role'),
              // ),
              // const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF43A047),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: loading ? null : _submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'DAFTAR',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label, {bool obscure = false}) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
      validator: (v) => v!.isEmpty ? '$label wajib diisi' : null,
      decoration: _decoration(label),
    );
  }

  Widget _confirmPasswordInput() {
    return TextFormField(
      controller: confirmPassCtrl,
      obscureText: true,
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Konfirmasi password wajib diisi';
        }
        if (v != passCtrl.text) {
          return 'Password tidak sama';
        }
        return null;
      },
      decoration: _decoration('Konfirmasi Password'),
    );
  }

  Widget _phoneInput() {
    return Row(
      children: [
        // Dropdown kode negara
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            value: selectedCode,
            underline: const SizedBox(),
            items: countryCodes.map((item) {
              return DropdownMenuItem(
                value: item['code'],
                child: Text('${item['code']}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCode = value!;
              });
            },
          ),
        ),

        const SizedBox(width: 10),

        // Input nomor HP
        Expanded(
          child: TextFormField(
            controller: nohp,
            keyboardType: TextInputType.phone,
            validator: (v) =>
                v == null || v.isEmpty ? 'Nomor HP wajib diisi' : null,
            decoration: _decoration('Nomor HP'),
          ),
        ),
      ],
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      );
}
