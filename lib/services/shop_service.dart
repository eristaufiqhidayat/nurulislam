import '../models/shop_model.dart';
import '../repositories/shop_repository.dart';

class ShopService {
  final repo = ShopRepository();
  Future<List<Map<String, dynamic>>> getDropdownShops() async {
    final shops = await repo.getAll();

    return shops.map((e) {
      return {
        'id': e.id,
        'name': e.name,
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDropdownCategories() async {
    final data = await repo.getAll();

    return data
        .map((e) => {
              'id': e.id,
              'name': e.name,
            })
        .toList();
  }

  Future<List<Shop>> getShops() async {
    try {
      return await repo.getAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<Shop> getShop(int id) async {
    try {
      return await repo.getById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createShop(Shop shop) async {
    try {
      await repo.create(shop);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateShop(int id, Shop shop) async {
    return await repo.update(id, shop);
  }

  Future<bool> deleteShop(int id) async {
    try {
      await repo.delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
