import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurulislam/pages/product/product_form_page_anggota.dart';
//import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../services/product_service.dart';
import '../../models/product_model.dart';
import 'product_form_page.dart';

import '../../config/api_constants.dart';

class ProductListPageAngggota extends StatefulWidget {
  const ProductListPageAngggota({super.key});

  @override
  State<ProductListPageAngggota> createState() =>
      _ProductListPageAngggotaState();
}

class _ProductListPageAngggotaState extends State<ProductListPageAngggota> {
  final ProductService service = ProductService();
  late Future<List<ProductModel>> future;
  String imageBaseUrl = '${ApiConstants.baseUrl}/storage/uploads/';
  final rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  bool loading = true;
  List<ProductModel> products = [];
  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() => loading = true);
    try {
      final result = await service.getProducts();
      if (!mounted) return;
      setState(() {
        products = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      print('Error fetching products: $e');
      //AuthHelper.handle401(context, message: e.toString());
    }
  }

  Future<void> refresh() async {
    await fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom(
          title: 'Products',
          leading: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: refresh,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductFormPageAnggota(
                        product: products[0],
                        baru: true,
                      )),
            );
            refresh();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        // ✅ IMAGE DI KIRI
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: p.image != null && p.image!.isNotEmpty
                              ? Image.network(
                                  '$imageBaseUrl${p.image}',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _imagePlaceholder();
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    );
                                  },
                                )
                              : _imagePlaceholder(),
                        ),

                        title: Text(
                          p.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rupiah.format(p.price),
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Stock: ${p.stock}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.orange.shade700,
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductFormPageAnggota(product: p),
                                  ),
                                );
                                refresh();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red.shade400,
                              onPressed: () async {
                                await service.delete(p.id);
                                refresh();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 56,
      height: 56,
      color: Colors.green.shade100,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.grey,
        size: 28,
      ),
    );
  }
}
