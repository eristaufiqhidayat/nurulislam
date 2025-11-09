class BarangHarga {
  final int? id;
  final int barangId;
  final String tanggal;
  final double hargaBeli;
  final double hargaJual;

  BarangHarga({
    this.id,
    required this.barangId,
    required this.tanggal,
    required this.hargaBeli,
    required this.hargaJual,
  });

  factory BarangHarga.fromJson(Map<String, dynamic> json) {
    return BarangHarga(
      id: json['id'],
      barangId: json['barang_id'],
      tanggal: json['tanggal'],
      hargaBeli: double.tryParse(json['harga_beli'].toString()) ?? 0.0,
      hargaJual: double.tryParse(json['harga_jual'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barang_id': barangId.toString(),
      'tanggal': tanggal,
      'harga_beli': hargaBeli.toString(),
      'harga_jual': hargaJual.toString(),
    };
  }
}
