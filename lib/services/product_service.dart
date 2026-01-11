import 'dart:io';

import '../repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductService {
  final ProductRepository repo = ProductRepository();

  Future<List<ProductModel>> getProducts() {
    print('Fetching products from ProductService');
    return repo.fetchProducts();
  }

  Future<String> uploadImage(File file) async {
    return repo.uploadImage(file);
  }

  Future<void> delete(int id) async {
    return repo.deleteProduct(id);
  }

  Future<void> save({
    required int shopId,
    required int categoryId,
    required String name,
    required double price,
    required int stock,
    required String status,
    required String desc,
    required File? imageFile,
  }) async {
    if (stock < 0) {
      throw Exception('Stock tidak boleh negatif');
    }

    await repo.storeProduct({
      "shop_id": 1,
      "category_id": 1,
      "name": name,
      "description": desc,
      "price": price,
      "stock": stock,
      "status": status
    });
  }
}
