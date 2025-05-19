class MenuItem {
  final String title;
  final String icon;
  final String route;
  final List<String> requiredRoles;

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.requiredRoles,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'],
      icon: json['icon'],
      route: json['route'],
      requiredRoles: List<String>.from(json['requiredRoles']),
    );
  }

  bool isAccessibleFor(String role) {
    return requiredRoles.contains(role);
  }
}
