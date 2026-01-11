import '../models/shop_model.dart';
import '../repositories/shop_repository.dart';

class ShopService {
  final ShopRepository repository = ShopRepository();

  Future<List<Map<String, dynamic>>> getShops({int page = 1}) {
    return repository.fetchShops(page: page);
  }

  Future<ShopModel> save({
    int? id,
    required String name,
    String? description,
    String? logo,
  }) {
    final data = {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'logo': logo,
    };

    return repository.saveShop(data);
  }

  Future<void> delete(int id) {
    return repository.deleteShop(id);
  }
}
