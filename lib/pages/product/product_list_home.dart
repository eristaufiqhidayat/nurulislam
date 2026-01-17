import 'package:flutter/material.dart';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/product_model.dart';
import 'package:nurulislam/services/product_service.dart';
import 'product_card.dart';

class ProductListHome extends StatefulWidget {
  const ProductListHome({super.key});

  @override
  State<ProductListHome> createState() => _ProductListHomeState();
}

class _ProductListHomeState extends State<ProductListHome> {
  final ProductService _service = ProductService();
  late Future<List<ProductModel>> futureProducts;

  final String imageBaseUrl = '${ApiConstants.baseUrl}/storage/uploads/';

  @override
  void initState() {
    super.initState();
    futureProducts = _service.getProductsList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================= TITLE ==================
        Text(
          'Nuris Shop',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),

        SizedBox(
          height: 270,
          child: FutureBuilder<List<ProductModel>>(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final products = snapshot.data ?? [];

              if (products.isEmpty) {
                return const Center(child: Text('Produk belum tersedia'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 170,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ProductCard(
                        product: products[index],
                        imageBaseUrl: imageBaseUrl,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
