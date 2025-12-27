import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/menuRole_model.dart';
import 'package:nurulislam/models/menu_check_model.dart';
import 'package:nurulislam/repositories/menuRole_repository.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class MenuRoleService {
  final _repo = MenuroleRepository();
  final String baseUrl = ApiConstants.baseUrl; // Base URL for API
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<MenuCheckModel>> fetchMenus(int roleId) async {
    return _repo.fetchMenus(roleId);
  }

  Future<void> saveMenus(int roleId, List<int> menuIds) async {
    return _repo.saveMenus(roleId, menuIds);
  }

  Future<List<MenuRole>> fetchAll() async {
    return _repo.fetchAll();
  }

  Future<void> create(String name) async {
    return _repo.create(name);
  }

  Future<void> update(int id, String name) async {
    return _repo.update(id, name);
  }

  Future<void> delete(int id) async {
    return _repo.delete(id);
  }
}
