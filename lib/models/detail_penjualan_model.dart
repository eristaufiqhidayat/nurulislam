import 'barang_model.dart';

class Penjualan {
  final int id;
  final int pembeliId;
  final DateTime tglTransaksi;
  final double totalHarga;
  final double totalModal;
  final double totalMargin;

  Penjualan({
    required this.id,
    required this.pembeliId,
    required this.tglTransaksi,
    required this.totalHarga,
    required this.totalModal,
    required this.totalMargin,
  });

  factory Penjualan.fromJson(Map<String, dynamic> json) => Penjualan(
        id: json['id'],
        pembeliId: json['pembeli_id'],
        tglTransaksi: DateTime.parse(json['tgl_transaksi']),
        totalHarga: double.parse(json['total_harga'].toString()),
        totalModal: double.parse(json['total_modal'].toString()),
        totalMargin: double.parse(json['total_margin'].toString()),
      );
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
