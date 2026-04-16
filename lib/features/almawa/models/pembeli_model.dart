class PembeliModel {
  final int id;
  final String nama;
  final String alamat;
  final String noTelepon;
  final DateTime createdAt;

  PembeliModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.noTelepon,
    required this.createdAt,
  });

  factory PembeliModel.fromJson(Map<String, dynamic> json) {
    return PembeliModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'no_telepon': noTelepon,
    };
  }
}
