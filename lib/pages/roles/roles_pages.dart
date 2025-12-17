import 'package:flutter/material.dart';
import 'package:nurulislam/services/role_services.dart';
import '../../models/role_model.dart';
import 'menu_role_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.green.shade100),
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Nama Role')),
                      DataColumn(label: Text('Menu')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: roles.map((role) {
                      return DataRow(cells: [
                        DataCell(Text(role.id.toString())),
                        DataCell(
                          SizedBox(
                            width: 120,
                            child: Text(
                              role.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.list),
                            onPressed: () {
                              setState(() {
                                selectedRoleId =
                                    selectedRoleId == role.id ? null : role.id;
                                selectedRoleName = role.name;
                              });
                            },
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.edit, color: Colors.orange),
                              Icon(Icons.delete, color: Colors.red),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
                if (selectedRoleId != null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Menu Akses: $selectedRoleName',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            MenuRoleWidget(roleId: selectedRoleId!),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
