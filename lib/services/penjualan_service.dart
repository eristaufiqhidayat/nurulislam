import 'package:nurulislam/repositories/penjualan_repository.dart';
import '../models/penjualan_model.dart';

class PenjualanService {
  // from api_constants.dart
  final _repo = PenjualanRepository();

  Future<PenjualanModel> create(PenjualanModel p) async {
    return await _repo.create(p);
  }

  Future<List<PenjualanModel>> fetchPenjualan() {
    //final headers = await _headers();
    return _repo.fetchPenjualan();
  }

  Future<PenjualanModel> fetchPenjualanBy(id) async {
    return await _repo.fetchPenjualanBy(id);
  }

  Future<bool> deletePenjualan(int id) async {
    return await _repo.deletePenjualan(id);
  }
}
