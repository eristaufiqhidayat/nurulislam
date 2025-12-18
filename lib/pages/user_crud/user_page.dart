import 'package:flutter/material.dart';
import 'package:nurulislam/pages/user_crud/user_table_mobile.dart';
import '../../models/user_crud_model.dart';
import '../../services/user_service.dart';
import 'user_form.dart';
import 'user_table.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserService _service = UserService();
  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      users = await _service.fetchUsers();
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data user')),
      );
    }
    setState(() => isLoading = false);
  }

  void showForm({UserModel? user}) {
    showDialog(
      context: context,
      builder: (_) => UserForm(
        user: user,
        onSubmit: (newUser, password, confirmPassword) async {
          try {
            if (user == null) {
              await _service.createUser(newUser, password: password);
            } else {
              await _service.updateUser(newUser, password: password);
            }
            await loadData();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menyimpan user: $e')),
            );
          }
        },
      ),
    );
  }

  void deleteUser(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus User'),
        content: Text('Yakin ingin menghapus ${user.name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteUser(user.id!);
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Daftar User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),

                // 🔥 INI KUNCI UTAMA
                Expanded(
                  child: UserTableMobile(
                    items: users,
                    onEdit: (user) => showForm(user: user),
                    onDelete: deleteUser,
                  ),
                ),
              ],
            ),
    );
  }
}
