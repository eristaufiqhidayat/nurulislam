import 'package:flutter/material.dart';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/product_model.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import '../../services/product_service.dart';
import 'product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _service = ProductService();
  late Future<List<ProductModel>> futureProducts;
  String imageBaseUrl = '${ApiConstants.baseUrl}/storage/uploads/';
  @override
  void initState() {
    super.initState();
    futureProducts = _service.getProductsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<ProductModel>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              if (snapshot.error.toString().contains('401')) {
                AuthHelper.handle401(context,
                    message:
                        "Sesi Anda telah berakhir. Silakan login kembali untuk melihat data penjualan.");
              } else {
                AuthHelper.handle401(context,
                    message: "Error memuat produk: ${snapshot.error}");
              }
            }

            final List<ProductModel> products = snapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(child: Text("Produk kosong"));
            }

            return GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: products[index],
                  imageBaseUrl: imageBaseUrl,
                );
              },
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   onPressed: () {
      //     // TODO: ke halaman tambah produk
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
