import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';
import 'menu_form.dart';
import 'menu_table.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuService _service = MenuService();
  List<MenuModel> menus = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    menus = await _service.fetchMenus();
    setState(() => loading = false);
  }

  void openForm({MenuModel? menu}) async {
    final result = await showDialog(
      context: context,
      builder: (_) => MenuForm(menu: menu),
    );

    if (result == true) loadData();
  }

  void delete(int id) async {
    await _service.delete(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Menu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : MenuTable(
              items: menus,
              onEdit: (m) => openForm(menu: m),
              onDelete: delete,
            ),
    );
  }
}
