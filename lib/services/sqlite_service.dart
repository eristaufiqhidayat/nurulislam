import 'package:nurulislam/repositories/sqllite_repository.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  final _repo = SqlliteRepository();

  // ignore: unused_element
  Future<Database> _initDb() async {
    return await _repo.initDb();
  }

  // ================= CRUD =================

  Future<int> insert(Map<String, dynamic> data) async {
    return _repo.insert(data);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    return _repo.getAll();
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    return _repo.update(id, data);
  }

  Future<int> delete(int id) async {
    return _repo.delete(id);
  }

  Future<void> clear() async {
    return _repo.clear();
  }
}
