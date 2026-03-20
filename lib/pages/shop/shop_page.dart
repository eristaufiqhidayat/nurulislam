import 'package:flutter/material.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../models/shop_model.dart';
import '../../services/shop_service.dart';
import 'shop_form_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final service = ShopService();

  List<Shop> shops = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() => loading = true);

    try {
      shops = await service.getShops();
    } catch (e) {
      // ignore: use_build_context_synchronously
      print(e);
      AuthHelper.handle401(context, message: e.toString());
      setState(() => loading = false);
    } finally {
      setState(() => loading = false);
    }
  }

  void openForm({Shop? shop}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopFormPage(shop: shop),
      ),
    );

    if (result == true) fetch();
  }

  void delete(int id) async {
    await service.deleteShop(id);
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'My Shops'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: shops.length,
              itemBuilder: (context, i) {
                final s = shops[i];

                return ListTile(
                  title: Text(s.name),
                  subtitle: Text(s.description ?? '-'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => openForm(shop: s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => delete(s.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
