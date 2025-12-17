import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';

class MenuForm extends StatefulWidget {
  final MenuModel? menu;
  const MenuForm({super.key, this.menu});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final _title = TextEditingController();
  final _route = TextEditingController();
  final _order = TextEditingController(text: '0');

  final MenuService _service = MenuService();

  @override
  void initState() {
    super.initState();
    if (widget.menu != null) {
      _title.text = widget.menu!.title;
      _route.text = widget.menu!.route ?? '';
      _order.text = widget.menu!.order.toString();
    }
  }

  void save() async {
    final menu = MenuModel(
      title: _title.text,
      route: _route.text,
      order: int.parse(_order.text),
    );

    if (widget.menu == null) {
      await _service.create(menu);
    } else {
      await _service.update(widget.menu!.id!, menu);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.menu == null ? 'Tambah Menu' : 'Edit Menu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title')),
          TextField(
              controller: _route,
              decoration: const InputDecoration(labelText: 'Route')),
          TextField(
            controller: _order,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Order'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        ElevatedButton(onPressed: save, child: const Text('Simpan')),
      ],
    );
  }
}
