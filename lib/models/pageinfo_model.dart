class PageinfoModel {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String? icon;

  PageinfoModel(
      {required this.id,
      required this.title,
      required this.description,
      this.image,
      this.icon});

  factory PageinfoModel.fromJson(Map<String, dynamic> json) {
    return PageinfoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      icon: json['icon'],
    );
  }
}
