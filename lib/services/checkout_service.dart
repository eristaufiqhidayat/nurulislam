import 'package:nurulislam/providers/cart_provider.dart';

class CheckoutService {
  /// Build payload checkout
  Map<String, dynamic> buildPayload(CartProvider cart) {
    final items = cart.items.map((item) {
      return {
        'product_id': item.product.id,
        'price': item.product.price,
        'qty': item.qty,
        'subtotal': item.subtotal,
      };
    }).toList();

    return {
      'total_items': cart.totalItems,
      'total_price': cart.totalPrice,
      'items': items,
    };
  }

  /// 🔥 METHOD YANG HILANG
  Future<void> checkout(CartProvider cart) async {
    //final payload = buildPayload(cart);

    // TODO: kirim ke API Laravel
    // contoh (nanti):
    // await api.post('/checkout', body: payload);

    // simulasi sukses checkout
    await Future.delayed(const Duration(milliseconds: 500));

    // clear cart setelah checkout sukses
    cart.clearCart();
  }
}
