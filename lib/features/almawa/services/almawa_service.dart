import 'package:nurulislam/features/almawa/repositories/almawa_repository.dart';

class AlmawaService {
  static Future<dynamic> get(String endpoint) async {
    return AlmawaRepository.get(endpoint);
  }

  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> data) async {
    return AlmawaRepository.post(endpoint, data);
  }

  Future<dynamic> getLaporan() async {
    return await get('transaksi/laporan');
  }

  Future<dynamic> cekStok() async {
    return await get('transaksi/cek-stok');
  }

  Future<dynamic> tambahPenjualan(
      int pembeliId, List<Map<String, dynamic>> barang) async {
    return await post('transaksi/penjualan', {
      'pembeli_id': pembeliId,
      'barang': barang,
    });
  }
}
