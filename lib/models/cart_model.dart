class Cart {
  final int id;
  final List<CartItem> items;

  Cart({required this.id, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      items: (json['items'] as List).map((e) => CartItem.fromJson(e)).toList(),
    );
  }
}

class CartItem {
  final int id;
  final int productId;
  final String productName;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  double get subtotal => quantity * price;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product']['name'] ?? '',
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
    );
  }
}
