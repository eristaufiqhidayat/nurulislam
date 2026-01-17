class Order {
  final int id;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.total,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'],
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }
}
