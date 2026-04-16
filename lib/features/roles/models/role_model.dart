class RoleModel {
  final int? id;
  final String name;

  RoleModel({this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
