import '../services/almawa_service.dart';

class TransaksiRepository {
  Future<dynamic> tambahBarangMasuk(int barangId, int jumlah) async {
    return await ApiService.post('transaksi/barang-masuk', {
      'barang_id': barangId,
      'jumlah': jumlah,
    });
  }

  Future<dynamic> tambahPembeli(
      String nama, String? alamat, String? telp) async {
    return await ApiService.post('transaksi/pembeli', {
      'nama': nama,
      'alamat': alamat,
      'no_telepon': telp,
    });
  }

  Future<dynamic> tambahPenjualan(
      int pembeliId, List<Map<String, dynamic>> barang) async {
    return await ApiService.post('transaksi/penjualan', {
      'pembeli_id': pembeliId,
      'barang': barang,
    });
  }

  Future<dynamic> getLaporan() async {
    return await ApiService.get('transaksi/laporan');
  }

  Future<dynamic> cekStok() async {
    return await ApiService.get('transaksi/cek-stok');
  }
}
