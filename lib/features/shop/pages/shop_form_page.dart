import 'package:flutter/material.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../../models/shop_model.dart';
import '../../../services/shop_service.dart';

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
  List<Shop> shops = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetch();
    // if (widget.shop != null) {
    //   nameCtrl.text = widget.shop!.name;
    //   descCtrl.text = widget.shop!.description ?? '';
    // }
  }

  Future<void> fetch() async {
    setState(() => loading = true);

    try {
      shops = await service.getShops();
      if (shops.isNotEmpty) {
        nameCtrl.text = shops[0].name;
        descCtrl.text = shops[0].description ?? '';
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      print(e);
      AuthHelper.handle401(context, message: e.toString());
      setState(() => loading = false);
    } finally {
      setState(() => loading = false);
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
      userId: 0,
      name: nameCtrl.text,
      description: descCtrl.text,
      logo: null,
    );

    bool success;

    if (widget.shop == null) {
      success = await service.createShop(shop);
    } else {
      await service.updateShop(widget.shop!.id, shop);
      success = true;
    }

    setState(() => loading = false);

    if (success) {
      AuthHelper.sukses(context, message: 'Sukses menyimpan shop');
      Navigator.pop(context); // 🔥 optional (kembali ke list)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: widget.shop == null ? 'Rubah Nama Shop' : 'Rubah Nama Shop',
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
