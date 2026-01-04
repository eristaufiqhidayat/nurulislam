import 'package:nurulislam/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../models/menu_model.dart';
import '../models/pageinfo_model.dart';
import 'package:sqflite/sqflite.dart';

class AuthService {
  final _repo = AuthRepository();
  // ✅ Menyimpan token setelah registrasi
  Future<User?> login(String email, String password) async {
    return await _repo.login(email, password);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    if (role == 'jamaah') {
      role = '10';
    } else if (role == 'panitia') {
      role = '11';
    }
    await _repo.register(
        name: name, email: email, password: password, role: role);
    // ✅ AUTO LOGIN
  }

  Future<User> verifyOtp(String email, String otp) async {
    return await _repo.verifyOtp(email, otp);
  }

  Future<List<MenuItem>> getUserMenu(String role) async {
    return await _repo.getUserMenu(role);
  }

  Future<User?> getUser() async {
    return await _repo.getUser();
  }

  Future<bool> isLoggedIn() async {
    return await _repo.isLoggedIn();
  }

  Future<void> logout() async {
    // ignore: unused_local_variable
    return await _repo.logout();
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
