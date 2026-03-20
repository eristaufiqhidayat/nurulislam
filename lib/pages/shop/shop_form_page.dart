import 'package:flutter/material.dart';
import '../../models/shop_model.dart';
import '../../services/shop_service.dart';

class ShopFormPage extends StatefulWidget {
  final Shop? shop;

  const ShopFormPage({super.key, this.shop});

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final ShopService service = ShopService();

  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.shop != null) {
      nameCtrl.text = widget.shop!.name;
      descCtrl.text = widget.shop!.description ?? '';
    }
  }

  Future<void> save() async {
    if (nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nama wajib diisi')));
      return;
    }

    setState(() => loading = true);

    final shop = Shop(
      id: widget.shop?.id ?? 0,
      userId: 0, // ❌ tidak dipakai backend
      name: nameCtrl.text,
      description: descCtrl.text,
      logo: null,
    );

    String? error;

    if (widget.shop == null) {
      error = (await service.createShop(shop)) as String?;
    } else {
      error = (await service.updateShop(widget.shop!.id, shop)) as String?;
    }

    setState(() => loading = false);

    if (error == null) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shop == null ? 'Tambah Shop' : 'Edit Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama Shop'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : save,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
