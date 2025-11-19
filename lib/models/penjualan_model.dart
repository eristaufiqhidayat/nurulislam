import 'pembeli_model.dart';
import 'detail_penjualan_model.dart';

class PenjualanModel {
  final int? id;
  final int pembeliId;
  final DateTime tglTransaksi;
  final double? totalHarga;
  final double? totalModal;
  final double? totalMargin;

  final PembeliModel? pembeli; // 🔥 tambahkan relasi
  final List<DetailPenjualan>? details; // 🔥 tambahkan list detail

  PenjualanModel({
    this.id,
    required this.pembeliId,
    required this.tglTransaksi,
    this.totalHarga,
    this.totalModal,
    this.totalMargin,
    this.pembeli,
    this.details,
  });

  factory PenjualanModel.fromJson(Map<String, dynamic> json) {
    return PenjualanModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? ''}'),

      pembeliId: json['pembeli_id'] is int
          ? json['pembeli_id']
          : int.tryParse('${json['pembeli_id'] ?? '0'}') ?? 0,

      tglTransaksi: json['tgl_transaksi'] != null
          ? DateTime.parse(json['tgl_transaksi'])
          : DateTime.now(),

      totalHarga: json['total_harga'] != null
          ? double.tryParse(json['total_harga'].toString())
          : null,

      totalModal: json['total_modal'] != null
          ? double.tryParse(json['total_modal'].toString())
          : null,

      totalMargin: json['total_margin'] != null
          ? double.tryParse(json['total_margin'].toString())
          : null,

      // 🔥 RELASI 1: PEMBELI
      pembeli: json['pembeli'] != null
          ? PembeliModel.fromJson(json['pembeli'])
          : null,

      // 🔥 RELASI 2: DETAILS
      details: json['details'] != null
          ? List<DetailPenjualan>.from(
              json['details'].map((d) => DetailPenjualan.fromJson(d)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pembeli_id': pembeliId,
      'tgl_transaksi': tglTransaksi.toIso8601String(),
    };
  }
}
