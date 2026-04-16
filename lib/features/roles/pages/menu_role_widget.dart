import 'package:flutter/material.dart';
import '../../menus/models/menu_check_model.dart';
import '../../menus/services/menuRole_service.dart';

class MenuRoleWidget extends StatefulWidget {
  final int roleId;
  const MenuRoleWidget({super.key, required this.roleId});

  @override
  State<MenuRoleWidget> createState() => _MenuRoleWidgetState();
}

class _MenuRoleWidgetState extends State<MenuRoleWidget> {
  final MenuRoleService service = MenuRoleService();
  List<MenuCheckModel> menus = [];
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  @override
  void didUpdateWidget(covariant MenuRoleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.roleId != widget.roleId) {
      loadMenus();
    }
  }

  Future<void> loadMenus() async {
    setState(() => isLoading = true);
    menus = await service.fetchMenus(widget.roleId);
    setState(() => isLoading = false);
  }

  Future<void> save() async {
    setState(() => isSaving = true);

    final selectedIds = menus.where((e) => e.checked).map((e) => e.id).toList();

    await service.saveMenus(widget.roleId, selectedIds);

    setState(() => isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu role berhasil disimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...menus.map((menu) {
          return CheckboxListTile(
            value: menu.checked,
            onChanged: (val) {
              setState(() => menu.checked = val ?? false);
            },
            title: Text(menu.title),
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('Simpan'),
            onPressed: isSaving ? null : save,
          ),
        ),
      ],
    );
  }
}
