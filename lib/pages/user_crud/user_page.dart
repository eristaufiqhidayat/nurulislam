import 'package:flutter/material.dart';
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
        SnackBar(content: Text('Gagal memuat data')),
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
              // 🟢 Jika password dikirim dari form
              await _service.createUser(newUser, password: password);
            } else {
              await _service.updateUser(newUser);
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
      appBar: AppBar(
        title: const Text('Data User'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () => showForm(),
            icon: const Icon(Icons.add),
            tooltip: 'Tambah User',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: UserTable(
                  items: users,
                  onEdit: (user) => showForm(user: user),
                  onDelete: deleteUser,
                ),
              ),
            ),
    );
  }
}
