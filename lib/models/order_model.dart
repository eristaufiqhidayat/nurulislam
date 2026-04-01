import 'product_model.dart';

class Order {
  final int? id;
  final int? userId;
  final double totalAmount;
  final String status;
  final String? paymentMethod;
  final String paymentStatus;
  final OrderAddress? address;
  final List<OrderItem> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Order({
    this.id,
    this.userId,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    required this.paymentStatus,
    this.address,
    required this.items,
    this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: double.parse(json['total_amount'].toString()),
      status: json['status'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      address: json['address'] != null
          ? OrderAddress.fromJson(json['address'])
          : null,
      items: json['items'] != null
          ? List<OrderItem>.from(
              json['items'].map((x) => OrderItem.fromJson(x)))
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "total_amount": totalAmount,
      "status": status,
      "payment_method": paymentMethod,
      "payment_status": paymentStatus,
      "address": address?.toJson(),
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int? id;
  final int? orderId;
  final int productId;
  final int quantity;
  final double price;
  final double subtotal;
  final ProductModel? product;

  OrderItem({
    this.id,
    this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.subtotal,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      subtotal: double.parse(json['subtotal'].toString()),
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "order_id": orderId,
      "product_id": productId,
      "quantity": quantity,
      "price": price,
      "subtotal": subtotal,
    };
  }
}

class OrderAddress {
  final int? id;
  final int? orderId;
  final String receiverName;
  final String phone;
  final String address;
  final String city;
  final String postalCode;

  OrderAddress({
    this.id,
    this.orderId,
    required this.receiverName,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
  });

  factory OrderAddress.fromJson(Map<String, dynamic> json) {
    return OrderAddress(
      id: json['id'],
      orderId: json['order_id'],
      receiverName: json['receiver_name'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postal_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "order_id": orderId,
      "receiver_name": receiverName,
      "phone": phone,
      "address": address,
      "city": city,
      "postal_code": postalCode,
    };
  }
}
