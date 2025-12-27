// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';

import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/repositories/menu_repository.dart';
import '../models/menu_model.dart';

class MenuService {
  final _repo = MenuRepository();
  static const String baseUrl = '${ApiConstants.baseUrl}/api/menus';

  Future<List<MenuModel>> fetchMenus() async {
    return await _repo.fetchMenus();
  }

  Future<void> create(MenuModel menu, File? icon) async {
    return await _repo.create(menu, icon);
  }

  Future<void> update(int id, MenuModel menu) async {
    return await _repo.update(id, menu);
  }

  Future<void> delete(int id) async {
    return await _repo.delete(id);
  }
}
