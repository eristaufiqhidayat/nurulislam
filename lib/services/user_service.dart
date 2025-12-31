// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps

import 'package:nurulislam/repositories/user_repository.dart';
import '../models/user_crud_model.dart';

class UserService {
  final _repo = UserRepository();

  Future<List<UserModel>> fetchUsers() async {
    return _repo.fetchUsers();
  }

  Future<List<Map<String, dynamic>>> fetchUsersmap() async {
    return _repo.fetchUsersmap();
  }

  Future<void> createUser(UserModel user, {String? password}) async {
    return _repo.createUser(user, password: password);
  }

  Future<void> updateUser(UserModel user, {String? password}) async {
    return _repo.updateUser(user, password: password);
  }

  Future<void> deleteUser(int id) async {
    return _repo.deleteUser(id);
  }
}
