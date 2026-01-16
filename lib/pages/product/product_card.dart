import 'package:flutter/material.dart';
import 'package:nurulislam/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String imageBaseUrl;

  const ProductCard({
    super.key,
    required this.product,
    required this.imageBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    print({
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'stock': product.stock,
      'image': product.image,
      'shopName': product.shopName,
      'categoryName': product.categoryName,
    });
    final String? imageUrl =
        product.image != null ? '$imageBaseUrl${product.image}' : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image),
                    ),
            ),
          ),

          // TEXT
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    product.shopName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Rp ${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.stock > 0 ? "Stok ${product.stock}" : "Habis",
                    style: TextStyle(
                      fontSize: 11,
                      color: product.stock > 0 ? Colors.grey : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
