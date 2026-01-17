import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:nurulislam/models/product_model.dart';
import 'package:nurulislam/providers/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductModel product;
  final String imageBaseUrl;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Detail Produk',
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text(
            'Tambah ke Keranjang',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            cart.addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Produk ditambahkan ke keranjang')),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              '$imageBaseUrl${product.image}',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${product.price}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(product.description ?? '-'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
