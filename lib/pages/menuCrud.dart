import 'package:flutter/material.dart';
import 'package:nurulislam/models/menu2_model.dart';
import 'package:nurulislam/services/menu_service.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuService _service = MenuService();
  List<Menu> _menus = [];
  int _currentPage = 1;
  int _perPage = 10;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  void _loadMenus() async {
    try {
      final menus =
          await _service.fetchMenus(page: _currentPage, perPage: _perPage);
      setState(() {
        _menus = menus;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _loadMenus();
  }

  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _loadMenus();
    }
  }

  void _deleteMenu(int id) async {
    await _service.deleteMenu(id);
    _loadMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _menus.length,
              itemBuilder: (context, index) {
                final menu = _menus[index];
                return ListTile(
                  title: Text(menu.title),
                  subtitle: Text(menu.route),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteMenu(menu.id),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: _prevPage, child: const Text('Previous')),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: _nextPage, child: const Text('Next')),
            ],
          )
        ],
      ),
    );
  }
}
