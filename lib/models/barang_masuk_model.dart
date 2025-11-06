class BarangMasukModel {
  final int id;
  final int barangId;
  final int jumlah;
  final DateTime tglMasuk;
  final double hargaBeli;
  final String supplier;

  BarangMasukModel({
    required this.id,
    required this.barangId,
    required this.jumlah,
    required this.tglMasuk,
    required this.hargaBeli,
    required this.supplier,
  });

  factory BarangMasukModel.fromJson(Map<String, dynamic> json) {
    return BarangMasukModel(
      id: json['id'],
      barangId: json['barang_id'],
      jumlah: json['jumlah'],
      tglMasuk: DateTime.parse(json['tgl_masuk']),
      hargaBeli: double.parse(json['harga_beli'].toString()),
      supplier: json['supplier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barang_id': barangId,
      'jumlah': jumlah,
      'tgl_masuk': tglMasuk.toIso8601String(),
      'harga_beli': hargaBeli,
      'supplier': supplier,
    };
  }
}
