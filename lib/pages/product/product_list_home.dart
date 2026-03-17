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

  Map<String, List<ProductModel>> groupByCategoryId(
      List<ProductModel> products) {
    final Map<String, List<ProductModel>> map = {};

    for (var product in products) {
      map.putIfAbsent(product.categoryName, () => []);
      map[product.categoryName]!.add(product);
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return const Center(child: Text('Produk belum tersedia'));
        }

        final grouped = groupByCategoryId(products);
        final sortedCategoryIds = grouped.keys.toList()..sort();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sortedCategoryIds.map((categoryId) {
            final items = grouped[categoryId]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== CATEGORY TITLE =====
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Nuris ${items.first.categoryName}', // aman
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                // ===== PRODUCT LIST =====
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ProductCard(
                            product: items[index],
                            imageBaseUrl: imageBaseUrl,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
