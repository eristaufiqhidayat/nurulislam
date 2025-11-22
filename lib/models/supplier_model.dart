class SupplierModel {
  final int? id;
  final String nama;
  final String alamat;
  final String telp;

  SupplierModel({
    this.id,
    required this.nama,
    required this.alamat,
    required this.telp,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? ''}'),
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      telp: json['telp'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      // ignore: unnecessary_null_comparison
      if (id != null) 'id': id,
      'nama': nama,
      'alamat': alamat,
      'telp': telp,
    };
  }
}
