import 'package:flutter/material.dart';

import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.qty);

  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);

  int? get currentShopId {
    if (_items.isEmpty) return null;
    return _items.values.first.product.shopId;
  }

  void addToCart(ProductModel product) {
    // 🔒 CEK SHOP ID
    if (currentShopId != null && currentShopId != product.shopId) {
      throw Exception('Cart hanya boleh dari satu toko');
    }

    if (_items.containsKey(product.id)) {
      _items[product.id]!.qty++;
    } else {
      _items[product.id] = CartItem(product: product);
    }

    notifyListeners();
  }

  // ➕ TAMBAH QTY
  void increaseQty(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.qty++;
      notifyListeners();
    }
  }

  // ➖ KURANG QTY
  void decreaseQty(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.qty > 1) {
      _items[productId]!.qty--;
    } else {
      _items.remove(productId); // qty 0 → hapus
    }
    notifyListeners();
  }

  // 🗑️ HAPUS ITEM
  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final ProductModel product;
  int qty;

  CartItem({
    required this.product,
    this.qty = 1,
  });

  double get subtotal => product.price * qty;
}
