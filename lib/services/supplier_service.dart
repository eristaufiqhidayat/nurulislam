// ignore_for_file: avoid_print
import 'package:nurulislam/models/supplier_model.dart';
import 'package:nurulislam/repositories/supplier_repository.dart';

class SupplierService {
  final _repo = SupplierRepository();

  Future<List<SupplierModel>> fetch() async {
    return await _repo.fetch();
  }

  Future<SupplierModel> fetchBy(id) async {
    return await _repo.fetchBy(id);
  }

  Future<void> create(SupplierModel item) async {
    return await _repo.create(item);
  }

  Future<void> update(int id, SupplierModel item) async {
    return await _repo.update(id, item);
  }

  Future<bool> delete(int id) async {
    return await _repo.delete(id);
  }
}
