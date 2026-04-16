import 'package:flutter/material.dart';
import 'package:nurulislam/features/roles/services/role_services.dart';
import '../models/role_model.dart';
import 'menu_role_widget.dart';
import 'role_form_dialog.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  final RoleService _service = RoleService();
  List<RoleModel> roles = [];
  bool isLoading = true;

  int? selectedRoleId;
  String? selectedRoleName;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    roles = await _service.fetchRoles();
    setState(() => isLoading = false);
  }

  // void showMenuRoleDialog(int roleId, String roleName) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => AlertDialog(
  //       title: Text(
  //         'Menu Akses 1 $roleName',
  //         style: const TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       content: SizedBox(
  //           width: double.maxFinite,
  //           child: SizedBox(
  //             height: MediaQuery.of(context).size.height * 0.7,
  //             child:
  //                 SingleChildScrollView(child: MenuRoleWidget(roleId: roleId)),
  //           )),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Tutup'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void confirmDelete(int role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Role'),
        content: Text('Yakin ingin menghapus role "$role"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _service.deleteRole(role);

              // 🔥 RESET STATE PENTING
              setState(() {
                if (selectedRoleId == role) {
                  selectedRoleId = null;
                  selectedRoleName = null;
                }
              });

              Navigator.pop(context);
              loadData();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void showMenuRoleCustomDialog(int roleId, String roleName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.all(12),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            width: double.infinity,
            child: Column(
              children: [
                // 🔰 HEADER
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Menu Akses 2 $roleName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),

                // 📦 CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SingleChildScrollView(
                        child: MenuRoleWidget(roleId: roleId)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showMenuRoleFullscreen(int roleId, String roleName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 🔥 fullscreen
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text(
                'Menu Akses 3 $roleName',
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child:
                  SingleChildScrollView(child: MenuRoleWidget(roleId: roleId)),
            ),
          ),
        );
      },
    );
  }

  void showMenuRoleBottomSheet(int roleId, String roleName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    // 🔰 HEADER
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Menu Akses : $roleName',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),

                    // 📦 CONTENT
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: MenuRoleWidget(roleId: roleId),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMobileList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        role.id.toString(),
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      role.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.list, size: 18),
                      label: const Text('Menu'),
                      onPressed: () {
                        showMenuRoleBottomSheet(role.id!, role.name);
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => RoleFormDialog(
                                role: role,
                                onSuccess: loadData,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            confirmDelete(role.id!);
                            loadData();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => RoleFormDialog(
              onSuccess: loadData,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: buildMobileList(),
                )
              ],
            ),
    );
  }
}
