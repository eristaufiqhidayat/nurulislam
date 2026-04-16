import 'barang_model.dart';

class BarangMasukModel {
  final int? id;
  final int idinv;
  final int barangId;
  final String? namaBarang;
  final int jumlah;
  final DateTime tglMasuk;
  final double hargaBeli;
  final String? supplier;
  final BarangModel? barang; //

  BarangMasukModel({
    this.id,
    required this.idinv,
    required this.barangId,
    this.namaBarang,
    required this.jumlah,
    required this.tglMasuk,
    required this.hargaBeli,
    this.supplier,
    this.barang,
  });

  factory BarangMasukModel.fromJson(Map<String, dynamic> json) {
    return BarangMasukModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      idinv: int.tryParse(json['id_inv'].toString()) ?? 0,
      barangId: int.tryParse(json['barang_id'].toString()) ?? 0,
      namaBarang: json['nama_barang'],
      jumlah: int.tryParse(json['jumlah'].toString()) ?? 0,
      tglMasuk: DateTime.parse(json['tanggal_masuk'].toString()),
      hargaBeli: double.tryParse(json['harga_beli'].toString()) ?? 0.0,
      supplier: json['supplier'],
      barang:
          json['barang'] != null ? BarangModel.fromJson(json['barang']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_inv': idinv,
      'barang_id': barangId,
      'jumlah': jumlah,
      // ✅ Laravel masih pakai nama `tanggal_masuk`, bukan `tgl_masuk`
      'tanggal_masuk': tglMasuk.toIso8601String(),
      'harga_beli': hargaBeli,
      'supplier': supplier,
    };
  }
}
