class Product {
  final int id;
  final int shopId;
  final int categoryId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? image;
  final String status;

  Product({
    required this.id,
    required this.shopId,
    required this.categoryId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.image,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      shopId: json['shop_id'],
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      image: json['image'],
      status: json['status'],
    );
  }
}
