import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductService {
  final ProductRepository repo = ProductRepository();
  Future<List<String>> uploadMultipleImages({
    List<File>? files,
    List<Uint8List>? webBytes,
  }) {
    return repo.uploadMultipleImages(files: files, webBytes: webBytes);
  }

  Future<List<ProductModel>> getProducts() {
    //print('Fetching products from ProductService');
    return repo.fetchProducts();
  }

  Future<List<ProductModel>> getProductsList() {
    //print('Fetching products from ProductService');
    return repo.fetchProductsList();
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
    required List<String> images,
  }) async {
    if (stock < 0) {
      throw Exception('Stock tidak boleh negatif');
    }
    print(
        'Menyimpan produk baru dengan data: shopId=$shopId, categoryId=$categoryId, name=$name, price=$price, stock=$stock, status=$status, desc=$desc, images=$images');
    await repo.storeProduct({
      "shop_id": shopId,
      "category_id": categoryId,
      "name": name,
      "description": desc,
      "price": price,
      "stock": stock,
      "status": status,
      "image": images.isNotEmpty ? images[0] : null,
      "imageJson": images
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
    required List<String> images,
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
      "image": images
    });
  }
}
