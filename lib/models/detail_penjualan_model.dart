import 'barang_model.dart';
import 'pembeli_model.dart';

class Penjualan {
  final int id;
  final int pembeliId;
  final DateTime tglTransaksi;
  final double totalHarga;
  final double totalModal;
  final double totalMargin;
  final PembeliModel? pembeli; // 🔥 Tambahan
  final List<DetailPenjualan>? details; // 🔥 Tambahan (list)

  Penjualan({
    required this.id,
    required this.pembeliId,
    required this.tglTransaksi,
    required this.totalHarga,
    required this.totalModal,
    required this.totalMargin,
    this.pembeli,
    this.details,
  });

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    return Penjualan(
      id: json['id'],
      pembeliId: json['pembeli_id'],
      tglTransaksi: DateTime.parse(json['tgl_transaksi']),
      totalHarga: double.parse(json['total_harga'].toString()),
      totalModal: double.parse(json['total_modal'].toString()),
      totalMargin: double.parse(json['total_margin'].toString()),

      // 🔥 Parsing pembeli (object)
      pembeli: json['pembeli'] != null
          ? PembeliModel.fromJson(json['pembeli'])
          : null,

      // 🔥 Parsing details (list)
      details: json['details'] != null
          ? List<DetailPenjualan>.from(
              json['details'].map((d) => DetailPenjualan.fromJson(d)),
            )
          : [],
    );
  }
}

class DetailPenjualan {
  final int? id;
  final int penjualanId;
  final int barangId;
  int jumlah;
  double hargaJual;
  double hargaBeli;
  double margin;
  BarangModel? barang;
  Penjualan? penjualan;

  DetailPenjualan({
    this.id,
    required this.penjualanId,
    required this.barangId,
    required this.jumlah,
    required this.hargaJual,
    required this.hargaBeli,
    required this.margin,
    this.barang,
    this.penjualan,
  });

  factory DetailPenjualan.fromJson(Map<String, dynamic> json) =>
      DetailPenjualan(
        id: json['id'],
        penjualanId: json['penjualan_id'],
        barangId: json['barang_id'],
        jumlah: json['jumlah'] is int
            ? json['jumlah']
            : int.parse(json['jumlah'].toString()),
        hargaJual: double.parse(json['harga_jual'].toString()),
        hargaBeli: double.parse(json['harga_beli'].toString()),
        margin: double.parse(json['margin'].toString()),
        barang: json['barang'] != null
            ? BarangModel.fromJson(json['barang'])
            : null,
        penjualan: json['penjualan'] != null
            ? Penjualan.fromJson(json['penjualan'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'penjualan_id': penjualanId,
        'barang_id': barangId,
        'jumlah': jumlah,
        'harga_jual': hargaJual,
        'harga_beli': hargaBeli,
        'margin': margin,
      };
}

class HargaResponse {
  final bool success;
  final int barangId;
  final String tanggalBerlaku;
  final String tanggalInput;
  final double hargaBeli;
  final double hargaJual;
  final String? message;

  HargaResponse({
    required this.success,
    required this.barangId,
    required this.tanggalBerlaku,
    required this.tanggalInput,
    required this.hargaBeli,
    required this.hargaJual,
    this.message,
  });

  factory HargaResponse.fromJson(Map<String, dynamic> json) {
    return HargaResponse(
      success: json['success'] ?? false,
      barangId:
          int.tryParse(json['barang_id'].toString()) ?? 0, // ✅ fix di sini
      tanggalBerlaku: json['tanggal_berlaku'] ?? '',
      tanggalInput: json['tanggal_input'] ?? '',
      hargaBeli: double.tryParse(json['harga_beli'].toString()) ?? 0,
      hargaJual: double.tryParse(json['harga_jual'].toString()) ?? 0,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'barang_id': barangId,
      'tanggal_berlaku': tanggalBerlaku,
      'tanggal_input': tanggalInput,
      'harga_beli': hargaBeli,
      'harga_jual': hargaJual,
      'message': message,
    };
  }
}
