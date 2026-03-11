import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nurulislam/config/api_constants.dart';
import '../../models/menu_model.dart';
import '../../services/menu_service.dart';
import 'package:image_picker/image_picker.dart';

class MenuForm extends StatefulWidget {
  final MenuModel? menu;
  const MenuForm({super.key, this.menu});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  final _title = TextEditingController();
  final _route = TextEditingController();
  final _icon = TextEditingController();
  final _order = TextEditingController(text: '0');

  final MenuService _service = MenuService();
  File? _iconImage;
  final ImagePicker _picker = ImagePicker();
  final String baseUrl = ApiConstants.baseUrl;

  @override
  void initState() {
    super.initState();
    if (widget.menu != null) {
      _title.text = widget.menu!.title;
      _route.text = widget.menu!.route ?? '';
      _order.text = widget.menu!.order.toString();
      _icon.text = widget.menu!.icon ?? '';
    }
  }

  Future<void> pickIcon() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        _iconImage = File(picked.path);
      });
    }
  }

  void save() async {
    final menu = MenuModel(
      title: _title.text,
      route: _route.text,
      order: int.parse(_order.text),
      icon: _icon.text,
    );
    if (widget.menu == null) {
      await _service.create(menu, _iconImage);
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
          TextField(
            controller: _icon,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Icon'),
          ),
          GestureDetector(
            onTap: pickIcon,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _iconImage != null
                  ? Image.file(_iconImage!, fit: BoxFit.cover)
                  : widget.menu?.icon != null
                      ? Image.network(
                          '$baseUrl/storage/uploads/${widget.menu!.icon}',
                          fit: BoxFit.cover,
                        )
                      : const Center(child: Text('Upload Icon')),
            ),
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
