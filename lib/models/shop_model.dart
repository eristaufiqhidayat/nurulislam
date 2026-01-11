class ShopModel {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final String? logo;

  ShopModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.logo,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'logo': logo,
    };
  }
}
