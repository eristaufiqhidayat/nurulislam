import 'package:nurulislam/features/almawa/models/detail_penjualan_model.dart';
import 'package:nurulislam/features/almawa/repositories/barang_harga_repository.dart';
import '../models/barang_harga_model.dart'; // pastikan file ini berisi baseUrl & headers()

class BarangHargaService {
  final _repo = BarangHargaRepository();
  Future<List<BarangHarga>> fetchAll() async {
    return await _repo.fetchAll();
  }

  Future<void> create(BarangHarga item) async {
    return await _repo.create(item);
  }

  Future<void> update(BarangHarga item) async {
    return await _repo.update(item);
  }

  Future<void> delete(int id) async {
    return await _repo.delete(id);
  }

  Future<HargaResponse> getHarga({
    required int barangId,
    required String tanggal,
  }) async {
    return await _repo.getHarga(
      barangId: barangId,
      tanggal: tanggal,
    );
  }
}
