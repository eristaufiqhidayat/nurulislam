import 'product_model.dart';

int? toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

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
      id: toInt(json['id']),
      userId: toInt(json['user_id']),
      totalAmount: toDouble(json['total_amount']),
      status: json['status'] ?? '',
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'] ?? '',
      address: json['address'] != null
          ? OrderAddress.fromJson(json['address'])
          : null,
      items: (json['items'] as List? ?? [])
          .map((x) => OrderItem.fromJson(x))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
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
      id: toInt(json['id']),
      orderId: toInt(json['order_id']),
      productId: toInt(json['product_id']) ?? 0,
      quantity: toInt(json['quantity']) ?? 0,
      price: toDouble(json['price']),
      subtotal: toDouble(json['subtotal']),
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
      id: toInt(json['id']),
      orderId: toInt(json['order_id']),
      receiverName: json['receiver_name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
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
