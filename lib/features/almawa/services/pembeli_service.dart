import 'package:nurulislam/features/almawa/repositories/pembeli_repository.dart';
import '../../../models/pembeli_model.dart';

class PembeliService {
  final _repo = PembeliRepository();
  final String token;
  PembeliService(this.token);

  Future<List<PembeliModel>> fetchPembelis(int page) async {
    return await _repo.fetchPembelis(page);
  }

  Future<void> create(PembeliModel pembeli) async {
    return await _repo.create(pembeli);
  }

  Future<void> update(int id, PembeliModel pembeli) async {
    return await _repo.update(id, pembeli);
  }

  Future<void> delete(int id) async {
    return await _repo.delete(id);
  }
}
