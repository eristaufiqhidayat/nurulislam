import 'package:nurulislam/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../models/menu_model.dart';
import '../models/pageinfo_model.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {
  final _repo = AuthRepository();
  Future<User?> login(String email, String password) async {
    return await _repo.login(email, password);
  }

  static Future<List<MenuItem>> getUserMenu(String role) async {
    return await AuthRepository.getUserMenu(role);
  }

  static Future<User?> getUser() async {
    return await AuthRepository.getUser();
  }

  static Future<bool> isLoggedIn() async {
    return await AuthRepository.isLoggedIn();
  }

  static Future<void> logout() async {
    // ignore: unused_local_variable
    return await AuthRepository.logout();
  }
}

class ApiService {
  final _repo = ApiRepository();
  Future<Database> get database async {
    return await _repo.database;
  }

  Future<List<PageinfoModel>> getByCategory(String category) async {
    return await _repo.getByCategory(category);
  }

  Future<void> upsertAll(List<PageinfoModel> list) async {
    return await _repo.upsertAll(list);
  }

  Future<List<PageinfoModel>> fetchPosts(String category) async {
    return await _repo.fetchPosts(category);
  }
}
