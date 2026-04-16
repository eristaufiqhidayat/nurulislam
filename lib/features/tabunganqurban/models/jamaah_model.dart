class JamaahModel {
  final int id;
  final String name;
  final String email;

  JamaahModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory JamaahModel.fromJson(Map<String, dynamic> json) {
    return JamaahModel(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}
