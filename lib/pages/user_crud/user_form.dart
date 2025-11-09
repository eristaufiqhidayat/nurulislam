import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Tambahkan di pubspec.yaml
import '../../models/user_crud_model.dart';

class UserForm extends StatefulWidget {
  final UserModel? user;
  final Function(UserModel, String?, String?) onSubmit; // password & confirm
  const UserForm({super.key, this.user, required this.onSubmit});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController roleController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    roleController =
        TextEditingController(text: widget.user?.roleId?.toString() ?? '');
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return AlertDialog(
      backgroundColor: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(
            isEdit ? Icons.edit : Icons.person_add,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 10),
          Text(
            isEdit ? 'Edit User' : 'Tambah User',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(
                controller: nameController,
                label: 'Nama Lengkap',
                icon: Icons.person,
                validator: (v) =>
                    v!.isEmpty ? 'Nama lengkap wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              _buildField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Email wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              _buildField(
                controller: roleController,
                label: 'Role ID',
                icon: Icons.admin_panel_settings,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              if (!isEdit) ...[
                _buildPasswordField(
                  controller: passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  show: showPassword,
                  onToggle: () => setState(() => showPassword = !showPassword),
                ),
                const SizedBox(height: 8),
                _buildPasswordField(
                  controller: confirmPasswordController,
                  label: 'Konfirmasi Password',
                  icon: Icons.lock_outline,
                  show: showConfirmPassword,
                  onToggle: () => setState(
                      () => showConfirmPassword = !showConfirmPassword),
                  validator: (v) {
                    if (v!.isEmpty) return 'Konfirmasi password wajib diisi';
                    if (v != passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.close, color: Colors.grey),
          label: const Text('Batal', style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.save),
          label: const Text('Simpan'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newUser = UserModel(
                id: widget.user?.id,
                name: nameController.text,
                email: emailController.text,
                roleId: int.tryParse(roleController.text),
              );
              widget.onSubmit(
                newUser,
                passwordController.text.isNotEmpty
                    ? passwordController.text
                    : null,
                confirmPasswordController.text.isNotEmpty
                    ? confirmPasswordController.text
                    : null,
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool show,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_off : Icons.visibility,
            color: Colors.green.shade700,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
