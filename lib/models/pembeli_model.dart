class Pembeli {
  final int id;
  final String nama;
  final String? alamat;
  final String? noTelepon;

  Pembeli({required this.id, required this.nama, this.alamat, this.noTelepon});

  factory Pembeli.fromJson(Map<String, dynamic> json) => Pembeli(
        id: json['id'],
        nama: json['nama'],
        alamat: json['alamat'],
        noTelepon: json['no_telepon'],
      );
}
