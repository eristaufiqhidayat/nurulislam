class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String? message;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
    this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      role: json['role'].toString(),
      token: json['token'].toString(),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'token': token,
      };
}
