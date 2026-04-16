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
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      status: json['status'] ?? '',
      image: json['image'],
      imageJson:
          (json['imageJson'] as List?)?.map((e) => e.toString()).toList(),
      shopId: int.tryParse(json['shop_id'].toString()) ?? 0,
      categoryId: int.tryParse(json['category_id'].toString()) ?? 0,

      // 🔥 FIX DI SINI
      shopName: json['shop'] != null ? json['shop']['name'] ?? '' : '',
      categoryName:
          json['category'] != null ? json['category']['name'] ?? '' : '',
    );
  }
  factory ProductModel.empty() {
    return ProductModel(
      id: 0,
      name: '',
      description: '',
      price: 0,
      stock: 0,
      status: '',
      image: '',
      shopId: 0,
      categoryId: 0,
      shopName: '',
      categoryName: '',
      imageJson: [],
    );
  }
}
