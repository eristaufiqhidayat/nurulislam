class BarangModel {
  final int? id;
  final String namaBarang;
  final String kategori;
  final String satuan;
  final double hargaBeli;
  final double hargaJual;
  final int stok;

  BarangModel({
    this.id,
    required this.namaBarang,
    required this.kategori,
    required this.satuan,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      id: int.tryParse(json['id']?.toString() ?? '0'),
      namaBarang: json['nama_barang']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      satuan: json['satuan']?.toString() ?? '',
      hargaBeli: double.tryParse(json['harga_beli']?.toString() ?? '0') ?? 0,
      hargaJual: double.tryParse(json['harga_jual']?.toString() ?? '0') ?? 0,
      stok: int.tryParse(json['stok']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_barang': namaBarang,
      'kategori': kategori,
      'satuan': satuan,
      'harga_beli': hargaBeli,
      'harga_jual': hargaJual,
      'stok': stok,
    };
  }

  BarangModel copyWith({
    int? id,
    String? namaBarang,
    String? kategori,
    String? satuan,
    double? hargaBeli,
    double? hargaJual,
    int? stok,
  }) {
    return BarangModel(
      id: id ?? this.id,
      namaBarang: namaBarang ?? this.namaBarang,
      kategori: kategori ?? this.kategori,
      satuan: satuan ?? this.satuan,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      stok: stok ?? this.stok,
    );
  }

  @override
  String toString() => 'BarangModel(id: $id, nama: $namaBarang, stok: $stok)';
}
