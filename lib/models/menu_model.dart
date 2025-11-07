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
