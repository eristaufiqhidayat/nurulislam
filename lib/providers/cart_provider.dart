import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _service = CartService();

  List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.qty);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.subtotal);

  int? get currentShopId {
    if (_items.isEmpty) return null;
    return _items.first.product.shopId;
  }

  // 🔥 GET CART FROM API
  Future<void> fetchCart() async {
    _items = await _service.getCart();
    notifyListeners();
  }

  // 🔥 ADD TO CART
  Future<void> addToCart(String productId) async {
    try {
      //print('tambahhhh');
      await _service.addToCart(productId);
      await fetchCart();
    } catch (e) {
      print(e.toString());
    }
  }

  // ➕ TAMBAH QTY
  Future<void> increaseQty(int cartId) async {
    final item = _items.firstWhere((e) => e.id == cartId);

    await _service.updateQty(cartId, item.qty + 1);
    await fetchCart();
  }

  // ➖ KURANG QTY
  Future<void> decreaseQty(int cartId) async {
    final item = _items.firstWhere((e) => e.id == cartId);

    if (item.qty > 1) {
      await _service.updateQty(cartId, item.qty - 1);
    } else {
      await _service.remove(cartId);
    }

    await fetchCart();
  }

  // 🗑️ HAPUS ITEM
  Future<void> removeItem(int cartId) async {
    await _service.remove(cartId);
    await fetchCart();
  }

  // 🔥 CLEAR CART (optional API)
  Future<void> clearCart() async {
    await _service.clearCart();
    _items = [];
    notifyListeners();
  }
}
