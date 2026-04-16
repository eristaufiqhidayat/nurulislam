import 'package:flutter/material.dart';
import '../models/role_model.dart';
import '../../menus/services/menuRole_service.dart';

class RoleFormDialog extends StatefulWidget {
  final RoleModel? role;
  final VoidCallback onSuccess;

  const RoleFormDialog({
    super.key,
    this.role,
    required this.onSuccess,
  });

  @override
  State<RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends State<RoleFormDialog> {
  final MenuRoleService _service = MenuRoleService();
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.role?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    if (widget.role == null) {
      await _service.create(_nameController.text.trim());
    } else {
      await _service.update(
        widget.role!.id!,
        _nameController.text.trim(),
      );
    }

    setState(() => isLoading = false);

    widget.onSuccess();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.role == null ? 'Tambah Role' : 'Edit Role'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Nama Role',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: isLoading ? null : submit,
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }
}
