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

class DetailPenjualan {
  final int id;
  final int barangId;
  final int jumlah;
  final double hargaJual;
  final double hargaBeli;
  final double margin;
  final Barang barang;

  DetailPenjualan({
    required this.id,
    required this.barangId,
    required this.jumlah,
    required this.hargaJual,
    required this.hargaBeli,
    required this.margin,
    required this.barang,
  });

  factory DetailPenjualan.fromJson(Map<String, dynamic> json) {
    return DetailPenjualan(
      id: json['id'] ?? 0,
      barangId: json['barang_id'] ?? 0,
      jumlah: json['jumlah'] ?? 0,
      hargaJual: double.tryParse(json['harga_jual']?.toString() ?? '0') ?? 0,
      hargaBeli: double.tryParse(json['harga_beli']?.toString() ?? '0') ?? 0,
      margin: double.tryParse(json['margin']?.toString() ?? '0') ?? 0,
      barang: Barang.fromJson(json['barang']), // 🟩 ambil nested object
    );
  }
}

class Pembeli {
  final int id;
  final String nama;
  final String alamat;
  final String noTelepon;

  Pembeli({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.noTelepon,
  });

  factory Pembeli.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Pembeli(id: 0, nama: '-', alamat: '-', noTelepon: '-');
    }

    return Pembeli(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '-',
      alamat: json['alamat'] ?? '-',
      noTelepon: json['no_telepon'] ?? '-',
    );
  }
}

class Penjualan {
  final int id;
  final int pembeliId;
  final String tglTransaksi;
  final double totalHarga;
  final double totalModal;
  final double totalMargin;
  final Pembeli pembeli;
  final List<DetailPenjualan> details;

  Penjualan({
    required this.id,
    required this.pembeliId,
    required this.tglTransaksi,
    required this.totalHarga,
    required this.totalModal,
    required this.totalMargin,
    required this.pembeli,
    required this.details,
  });

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    return Penjualan(
      id: json['id'] ?? 0,
      pembeliId: json['pembeli_id'] ?? 0,
      tglTransaksi: json['tgl_transaksi'] ?? '-',
      totalHarga: double.tryParse(json['total_harga']?.toString() ?? '0') ?? 0,
      totalModal: double.tryParse(json['total_modal']?.toString() ?? '0') ?? 0,
      totalMargin:
          double.tryParse(json['total_margin']?.toString() ?? '0') ?? 0,
      pembeli: Pembeli.fromJson(json['pembeli']),
      details: (json['details'] as List?)
              ?.map((e) => DetailPenjualan.fromJson(e))
              .toList() ??
          [],
    );
  }
}
