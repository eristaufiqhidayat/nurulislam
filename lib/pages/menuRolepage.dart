import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nurulislam/models/menuRole_model.dart';
import 'package:nurulislam/services/menuRole_service.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class MenuRolePage extends StatefulWidget {
  const MenuRolePage({Key? key}) : super(key: key);

  @override
  State<MenuRolePage> createState() => _MenuRolePageState();
}

class _MenuRolePageState extends State<MenuRolePage> {
  final service = MenuRoleService();
  List<MenuRole> _menuRoles = [];

  @override
  void initState() {
    super.initState();
    _loadMenuRoles();
  }

  Future<void> _loadMenuRoles() async {
    final data = await service.fetchAll();
    setState(() {
      _menuRoles = data;
    });
  }

  void _showForm([MenuRole? item]) {
    final roleController =
        TextEditingController(text: item?.roleId.toString() ?? '');
    final menuController =
        TextEditingController(text: item?.menuId.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item == null ? 'Tambah Menu Role' : 'Edit Menu Role',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: roleController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Role ID',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: menuController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Menu ID',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final roleId = int.tryParse(roleController.text);
              final menuId = int.tryParse(menuController.text);

              if (roleId == null || menuId == null) return;

              final menuRole = MenuRole(
                id: item?.id ?? 0,
                roleId: roleId,
                menuId: menuId,
              );

              if (item == null) {
                await service.create(menuRole);
              } else {
                await service.update(item.id, menuRole);
              }

              Navigator.pop(context);
              _loadMenuRoles();
            },
            child:
                Text('Simpan', style: GoogleFonts.poppins(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  void _delete(int id) async {
    await service.delete(id);
    _loadMenuRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: const Color(0xFF1565C0),
        scaffoldBackgroundColor: const Color(0xFFF3F6F9),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBarCustom(
          title: 'Menu Role Management',
          routeName: '/homepage',
        ),
        body: _menuRoles.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _menuRoles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = _menuRoles[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        '${item.roleName ?? 'Role ${item.roleId}'} → ${item.menuTitle ?? 'Menu ${item.menuId}'}',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showForm(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(item.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showForm(),
          backgroundColor: const Color(0xFF1565C0),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
