import 'package:nurulislam/repositories/page_info_repository.dart';
import '../models/pageinfo_model.dart';
import 'package:file_picker/file_picker.dart';

class PageInfoService {
  final String token;
  //final String pageInfoUrl = '${ApiConstants.baseUrl}/api/pageinfoCrud';
  //final String uploadUrl = '${ApiConstants.baseUrl}/api/upload-image';
  PageInfoService(this.token);
  final _repo = PageInfoRepository();

  Future<String> uploadImage(PlatformFile file) async {
    return await _repo.uploadImage(file);
  }

  Future<List<PageinfoModel>> fetchPageInfos(int page) async {
    return await _repo.fetchPageInfos(page);
  }

  Future<void> create(PageinfoModel item) async {
    return await _repo.create(item);
  }

  Future<void> update(int id, PageinfoModel item) async {
    return await _repo.update(id, item);
  }

  Future<void> delete(int id) async {
    return await _repo.delete(id);
  }
}
