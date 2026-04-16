class BarangHarga {
  final int? id;
  final int barangId;
  final String tanggal;
  final double hargaBeli;
  final double hargaJual;
  final Barang? barang;

  BarangHarga({
    this.id,
    required this.barangId,
    required this.tanggal,
    required this.hargaBeli,
    required this.hargaJual,
    this.barang,
  });

  factory BarangHarga.fromJson(Map<String, dynamic> json) {
    return BarangHarga(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      barangId: json['barang_id'] is int
          ? json['barang_id']
          : int.tryParse(json['barang_id'].toString()) ?? 0,
      tanggal: json['tanggal'] ?? '',
      hargaBeli: double.tryParse(json['harga_beli']?.toString() ?? '0') ?? 0,
      hargaJual: double.tryParse(json['harga_jual']?.toString() ?? '0') ?? 0,
      barang: Barang.fromJson(json['barang']),
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

class Barang {
  final int id;
  final String namaBarang;
  final String? kategori;
  final String? satuan;
  final double hargaBeli;
  final double hargaJual;

  Barang({
    required this.id,
    required this.namaBarang,
    this.kategori,
    this.satuan,
    required this.hargaBeli,
    required this.hargaJual,
  });

  factory Barang.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Barang(
        id: 0,
        namaBarang: '-',
        kategori: '-',
        satuan: '-',
        hargaBeli: 0,
        hargaJual: 0,
      );
    }

    return Barang(
      id: json['id'] ?? 0,
      namaBarang: json['nama_barang'] ?? '-',
      kategori: json['kategori'],
      satuan: json['satuan'],
      hargaBeli: double.tryParse(json['harga_beli']?.toString() ?? '0') ?? 0,
      hargaJual: double.tryParse(json['harga_jual']?.toString() ?? '0') ?? 0,
    );
  }
}
