import 'package:nurulislam/features/almawa/models/detail_penjualan_model.dart';
import 'package:nurulislam/features/almawa/repositories/detail_penjualan_repository.dart';

class DetailPenjualanService {
  final _repo = DetilPenjualanRepository();

  Future<HargaResponse> getHarga({
    required int barangId,
    required String tanggal,
  }) async {
    return await _repo.getHarga(barangId: barangId, tanggal: tanggal);
  }

  Future<List<DetailPenjualan>> fetchAll() async {
    return await _repo.fetchAll();
  }

  Future<List<DetailPenjualan>> fetchById(int id) async {
    return await _repo.fetchById(id);
  }

  Future<DetailPenjualan> create(DetailPenjualan d) async {
    return await _repo.create(d);
  }

  Future<DetailPenjualan> update(int id, DetailPenjualan d) async {
    return await _repo.update(id, d);
  }

  Future<void> delete(int id) async {
    return await _repo.delete(id);
  }
}
