class CategoryModel {
  final int id;
  final String name;
  final int? parentId;

  CategoryModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parent_id'],
    );
  }
}
