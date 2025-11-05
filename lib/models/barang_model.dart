class Barang {
  final int id;
  final String namaBarang;
  final String kategori;
  final String satuan;
  final double hargaBeli;
  final double hargaJual;
  final int stok;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.kategori,
    required this.satuan,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json['id'],
        namaBarang: json['nama_barang'],
        kategori: json['kategori'] ?? '',
        satuan: json['satuan'] ?? '',
        hargaBeli: (json['harga_beli'] ?? 0).toDouble(),
        hargaJual: (json['harga_jual'] ?? 0).toDouble(),
        stok: json['stok'] ?? 0,
      );
}
