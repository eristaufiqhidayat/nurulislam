import '../../../models/order_model.dart';
import '../repositories/order_repository.dart';

class OrderService {
  final repo = OrderRepository();

  Future<List<Order>> getOrders() async {
    try {
      return await repo.getAll();
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrder(int id) async {
    try {
      return await repo.getById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> create(Order order) async {
    try {
      await repo.create(order);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> update(int id, Order order) async {
    return await repo.update(id, order);
  }

  Future<bool> delete(int id) async {
    try {
      await repo.delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
