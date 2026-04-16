class MenuCheckModel {
  final int id;
  final String title;
  bool checked;

  MenuCheckModel({
    required this.id,
    required this.title,
    required this.checked,
  });

  factory MenuCheckModel.fromJson(Map<String, dynamic> json) {
    return MenuCheckModel(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      checked: json['checked'] == true,
    );
  }
}
