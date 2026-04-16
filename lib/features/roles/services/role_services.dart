import 'package:nurulislam/features/roles/repositories/role_repository.dart';
import '../models/role_model.dart';

class RoleService {
  final _role = RoleRepository();

  static Future<List<RoleModel>> getRoles() async {
    return await RoleRepository.getRoles();
  }

  Future<List<RoleModel>> fetchRoles() async {
    return await _role.fetchRoles();
  }

  Future<void> createRole(RoleModel role) async {
    return await _role.createRole(role);
  }

  Future<void> updateRole(RoleModel role) async {
    return await _role.updateRole(role);
  }

  Future<void> deleteRole(int id) async {
    return await _role.deleteRole(id);
  }
}
