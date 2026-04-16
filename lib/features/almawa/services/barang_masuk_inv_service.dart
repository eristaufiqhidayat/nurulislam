import 'package:nurulislam/features/almawa/models/barang_masuk_inv_model.dart';
import 'package:nurulislam/features/almawa/models/barang_masuk_model.dart';
import 'package:nurulislam/features/almawa/repositories/barang_masuk_inv_repository.dart';

class BarangMasukInvService {
  String route = 'barang-masuk-inv';
  final _repo = BarangMasukInvRepository();

  Future<List<BarangMasukInvModel>> fetch() async {
    return await _repo.fetch();
  }

  Future<BarangMasukInvModel> fetchBy(id) async {
    return await _repo.fetchBy(id);
  }

  Future<List<BarangMasukModel>?> lfetchBy(int id) async {
    return await _repo.lfetchBy(id);
  }

  Future<BarangMasukInvModel> create(BarangMasukInvModel p) async {
    return await _repo.create(p);
  }

  Future<void> update(int id, BarangMasukInvModel item) async {
    return await _repo.update(id, item);
  }

  Future<bool> delete(int id) async {
    return await _repo.delete(id);
  }
}
