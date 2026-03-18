class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String status;
  final String? image;
  final int shopId;
  final int categoryId;
  final String shopName;
  final String categoryName;
  final List<String>? imageJson;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.status,
    this.image,
    required this.shopId,
    required this.categoryId,
    required this.shopName,
    required this.categoryName,
    this.imageJson,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      status: json['status'],
      image: json['image'],
      imageJson: (json['imageJson'] as List?)
          ?.map((e) => e.toString())
          .toList(), // Pastikan ini sesuai dengan struktur data yang diterima
      shopId: int.parse(json['shop_id'].toString()),
      categoryId: int.parse(json['category_id'].toString()),
      shopName: json['shop']['name'],
      categoryName: json['category']['name'],
    );
  }
}
