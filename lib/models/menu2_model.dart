class Menu {
  final int id;
  final String title;
  final String route;
  final String icon;
  final int? parentId;
  final int order;

  Menu({
    required this.id,
    required this.title,
    required this.route,
    required this.icon,
    this.parentId,
    required this.order,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      title: json['title'],
      route: json['route'],
      icon: json['icon'],
      parentId: json['parent_id'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'route': route,
      'icon': icon,
      'parent_id': parentId,
      'order': order,
    };
  }
}
