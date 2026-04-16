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

  // ------------ FROM JSON ------------
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

  // ------------ TO JSON ------------
  Map<String, dynamic> toJson({bool forUpdate = false, String? password}) {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'role_id': roleId, // kirim integer saja
    };

    // CREATE USER
    if (!forUpdate) {
      if (password == null || password.isEmpty) {
        throw Exception("Password wajib untuk create user");
      }
      data['password'] = password;
    }

    // UPDATE USER → password opsional
    if (forUpdate && password != null && password.isNotEmpty) {
      data['password'] = password;
    }

    return data;
  }
}
