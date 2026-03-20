class Shop {
  final int id;
  final int userId;
  final String name;
  final String? description;
  final String? logo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Shop({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.logo,
    this.createdAt,
    this.updatedAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
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
      'user_id': userId,
      'name': name,
      'description': description,
      'logo': logo,
    };
  }
}
