class MenuItem {
  final String title;
  final String icon;
  final String route;
  final String color;

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.color = '',
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      route: json['route'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

class MenuModel {
  final int? id;
  final String title;
  final String? route;
  final String? icon;
  final int? parentId;
  final int order;
  final String? color;

  MenuModel({
    this.id,
    required this.title,
    this.route,
    this.icon,
    this.parentId,
    required this.order,
    this.color,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      title: json['title'],
      route: json['route'],
      icon: json['icon'],
      parentId: json['parent_id'],
      order: json['order'] ?? 0,
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'route': route,
      'icon': icon,
      'parent_id': parentId,
      'order': order,
      'color': color,
    };
  }
}
