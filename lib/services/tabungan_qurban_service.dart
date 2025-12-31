import '../models/tabungan_qurban_model.dart';
import '../repositories/tabungan_qurban_repository.dart';

class TabunganQurbanService {
  final TabunganQurbanRepository _repo = TabunganQurbanRepository();

  Future<List<TabunganQurbanModel>> fetchList({int page = 1}) async {
    final response = await _repo.fetchPaginated(page: page);
    final List data = response['data'];

    return data.map((e) => TabunganQurbanModel.fromJson(e)).toList();
  }

  Future<TabunganQurbanModel> fetchDetail(int id) async {
    final data = await _repo.fetchById(id);
    return TabunganQurbanModel.fromJson(data);
  }

  Future<void> create(Map<String, dynamic> data) async {
    await _repo.create({
      'jamaah_id': data['jamaahId'],
      'tahun_qurban': data['tahunQurban'],
      'target_hewan': data['targetHewan'],
      'target_nominal': data['targetNominal'],
      'total_setoran': data['totalSetoran'],
      'status': data['status'],
    });
  }

  Future<void> update(int id, TabunganQurbanModel model) async {
    await _repo.update(id, {
      'target_hewan': model.targetHewan,
      'target_nominal': model.targetNominal,
      'status': model.status,
    });
  }

  Future<void> delete(int id) async {
    await _repo.delete(id);
  }

  Future<void> addSetoran({
    required int tabunganId,
    required String tanggal,
    required double nominal,
    required String metode,
    String? keterangan,
  }) async {
    await _repo.addSetoran({
      'tabungan_id': tabunganId,
      'tanggal': tanggal,
      'nominal': nominal,
      'metode': metode,
      'keterangan': keterangan,
    });
  }
}
