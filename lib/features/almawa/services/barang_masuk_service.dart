import 'package:nurulislam/features/almawa/repositories/barang_masuk_repository.dart';
import '../../../config/api_constants.dart';
import '../models/barang_masuk_model.dart';

class BarangMasukService {
  static const String endpoint = '${ApiConstants.baseUrl}/api/barang-masuk';

  static Future<List<BarangMasukModel>> fetchAll() async {
    return await BarangMasukRepository.fetchAll();
  }

  /// ✅ POST: tambah data pembelian baru
  static Future<bool> create(Map<String, dynamic> data) async {
    return await BarangMasukRepository.create(data);
  }

  /// ✅ PUT: update data pembelian
  static Future<bool> update(int id, Map<String, dynamic> data) async {
    return await BarangMasukRepository.update(id, data);
  }

  /// ✅ DELETE: hapus data pembelian
  static Future<bool> delete(int id) async {
    return await BarangMasukRepository.delete(id);
  }
}
