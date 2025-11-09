class UserModel {
  final int? id;
  final String name;
  final String email;
  final int? roleId;
  final String? roleName;
  final String? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.roleId,
    this.roleName,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return UserModel(
      id: parseInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roleId: parseInt(json['role_id']),
      roleName: json['role'] != null ? json['role']['name'] : null,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson({bool forUpdate = false}) {
    final data = {
      'name': name,
      'email': email,
      'role_id': roleId?.toString() ?? '0',
    };

    if (!forUpdate) data['password'] = '123456'; // default password
    return data;
  }
}
