import 'package:nurulislam/repositories/barang_repository.dart';
import '../models/barang_model.dart';

class BarangService {
  final _repo = BarangRepository();

  Future<List<BarangModel>> fetchBarangs(int page) async {
    // Ambil token dari SharedPrefs
    return await _repo.fetchBarangs(page);
  }

  Future<void> create(BarangModel item) async {
    return await _repo.create(item);
  }

  Future<void> update(int id, BarangModel item) async {
    return await _repo.update(id, item);
  }

  Future<void> delete(int id) async {
    return await _repo.delete(id);
  }
}
