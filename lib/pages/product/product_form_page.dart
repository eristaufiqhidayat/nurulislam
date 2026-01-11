import 'package:flutter/material.dart';
import 'package:nurulislam/services/category_service.dart';
import 'package:nurulislam/services/shop_service.dart';
import 'package:nurulislam/widgets/dropdown_search_map.dart';
import '../../services/product_service.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final ProductService service = ProductService();
  final CategoryService serviceCategory = CategoryService();
  final ShopService serviceShop = ShopService();
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownSearchMap(
              fetchData: serviceShop.getShops,
              label: 'Shop',
              idKey: 'id',
              textKey: 'name',
              onChanged: (value) {
                // Handle category selection
              },
            ),
            DropdownSearchMap(
              fetchData: serviceCategory.getCategories,
              label: 'Category',
              idKey: 'id',
              textKey: 'name',
              onChanged: (value) {
                // Handle category selection
              },
            ),
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price')),
            TextField(
                controller: stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      await service.save(
                        name: nameCtrl.text,
                        price: double.parse(priceCtrl.text),
                        stock: int.parse(stockCtrl.text),
                      );
                      Navigator.pop(context);
                    },
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}
