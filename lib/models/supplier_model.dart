class SupplierModel {
  final int id;
  final String nama;
  final String alamat;
  final String telp;

  SupplierModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telp,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? ''}'),
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      telp: json['no_telp'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'telp': telp,
    };
  }
}
