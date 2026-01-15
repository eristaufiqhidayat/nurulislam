import 'dart:io';

import '../repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductService {
  final ProductRepository repo = ProductRepository();

  Future<List<ProductModel>> getProducts() {
    //print('Fetching products from ProductService');
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
    required String? imageFile,
  }) async {
    if (stock < 0) {
      throw Exception('Stock tidak boleh negatif');
    }

    await repo.storeProduct({
      "shop_id": shopId,
      "category_id": categoryId,
      "name": name,
      "description": desc,
      "price": price,
      "stock": stock,
      "status": status,
      "image": imageFile
    });
  }

  Future<void> update({
    required int id,
    required int shopId,
    required int categoryId,
    required String name,
    required double price,
    required int stock,
    required String status,
    required String desc,
    required String? imageFile,
  }) async {
    if (stock < 0) {
      throw Exception('Stock tidak boleh negatif');
    }

    await repo.updateProduct(id, {
      "shop_id": shopId,
      "category_id": categoryId,
      "name": name,
      "description": desc,
      "price": price,
      "stock": stock,
      "status": status,
      "image": imageFile
    });
  }
}
