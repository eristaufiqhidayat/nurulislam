import 'barang_model.dart';

class BarangMasukModel {
  final int id;
  final int idinv;
  final int barangId;
  final String namaBarang;
  final int jumlah;
  final DateTime tglMasuk;
  final double hargaBeli;
  final String supplier;
  final BarangModel? barang; //

  BarangMasukModel({
    required this.id,
    required this.idinv,
    required this.barangId,
    required this.namaBarang,
    required this.jumlah,
    required this.tglMasuk,
    required this.hargaBeli,
    required this.supplier,
    this.barang,
  });

  factory BarangMasukModel.fromJson(Map<String, dynamic> json) {
    return BarangMasukModel(
      id: json['id'] ?? 0,
      idinv: json['id_inv'] ?? 0,
      barangId: json['barang_id'] ?? 0,
      namaBarang: json['barang']?['nama_barang'] ?? '-',
      jumlah: json['jumlah'] ?? 0,
      // ✅ Ganti dari tgl_masuk → tanggal_masuk
      tglMasuk: (json['tanggal_masuk'] != null)
          ? DateTime.parse(json['tanggal_masuk'])
          : DateTime.now(),
      hargaBeli: double.tryParse(json['harga_beli']?.toString() ?? '0') ?? 0,
      supplier: json['supplier'] ?? '',
      barang:
          json['barang'] != null ? BarangModel.fromJson(json['barang']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barang_id': barangId,
      'jumlah': jumlah,
      // ✅ Laravel masih pakai nama `tanggal_masuk`, bukan `tgl_masuk`
      'tanggal_masuk': tglMasuk.toIso8601String(),
      'harga_beli': hargaBeli,
      'supplier': supplier,
    };
  }
}
