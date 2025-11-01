class MenuRole {
  final int id;
  final int roleId;
  final int menuId;
  final String? roleName;
  final String? menuTitle;

  MenuRole({
    required this.id,
    required this.roleId,
    required this.menuId,
    this.roleName,
    this.menuTitle,
  });

  factory MenuRole.fromJson(Map<String, dynamic> json) {
    return MenuRole(
      id: json['id'],
      roleId: json['role_id'],
      menuId: json['menu_id'],
      roleName: json['role']?['name'],
      menuTitle: json['menu']?['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_id': roleId,
      'menu_id': menuId,
    };
  }
}
