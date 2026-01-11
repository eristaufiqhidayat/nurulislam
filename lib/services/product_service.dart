import '../repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductService {
  final ProductRepository repo = ProductRepository();

  Future<List<ProductModel>> getProducts() {
    print('Fetching products from ProductService');
    return repo.fetchProducts();
  }

  Future<void> delete(int id) async {
    return repo.deleteProduct(id);
  }

  Future<void> save({
    required String name,
    required double price,
    required int stock,
  }) async {
    if (stock < 0) {
      throw Exception('Stock tidak boleh negatif');
    }

    await repo.storeProduct({
      "shop_id": 1,
      "category_id": 1,
      "name": name,
      "price": price,
      "stock": stock,
      "status": "active"
    });
  }
}
