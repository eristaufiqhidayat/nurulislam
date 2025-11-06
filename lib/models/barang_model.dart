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
      id: json['id'],
      namaBarang: json['nama_barang'],
      kategori: json['kategori'],
      satuan: json['satuan'],
      hargaBeli: double.tryParse(json['harga_beli'].toString()) ?? 0,
      hargaJual: double.tryParse(json['harga_jual'].toString()) ?? 0,
      stok: int.tryParse(json['stok'].toString()) ?? 0,
    );
  }

  Map<String, String> toJson() {
    return {
      'nama_barang': namaBarang,
      'kategori': kategori,
      'satuan': satuan,
      'harga_beli': hargaBeli.toString(),
      'harga_jual': hargaJual.toString(),
      'stok': stok.toString(),
    };
  }
}
