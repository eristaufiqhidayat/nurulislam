import '../../product/models/product_model.dart';

class CartItemModel {
  final int id;
  final ProductModel product;
  final int qty;

  CartItemModel({
    required this.id,
    required this.product,
    required this.qty,
  });

  double get subtotal => product.price * qty;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      qty: int.tryParse(json['quantity'].toString()) ?? 0,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : ProductModel.empty(),
    );
  }
}
