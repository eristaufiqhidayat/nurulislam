import '../repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryService {
  final CategoryRepository repo = CategoryRepository();

  Future<List<Map<String, dynamic>>> getCategories() {
    return repo.fetchCategories();
  }

  Future<List<CategoryModel>> getAll() {
    return repo.fetchAll();
  }

  Future<void> save({
    int? id,
    required String name,
    int? parentId,
  }) async {
    if (name.isEmpty) {
      throw Exception('Nama category wajib diisi');
    }

    await repo.save({
      'id': id,
      'name': name,
      'parent_id': parentId,
    });
  }

  Future<void> delete(int id) {
    return repo.delete(id);
  }
}
