class PageinfoModel {
  final int? id;
  final String title;
  final String description;
  final String image;
  final String icon;
  final String? category;

  PageinfoModel({
    this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
    this.category,
  });

  factory PageinfoModel.fromJson(Map<String, dynamic> json) {
    return PageinfoModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      icon: json['icon'] == null || json['icon'] == 'null' ? '' : json['icon'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'icon': icon,
      'category': category,
    };
  }

  String? get imageUrl {
    return image.isNotEmpty ? 'https://example.com/storage/$image' : null;
  }
}
