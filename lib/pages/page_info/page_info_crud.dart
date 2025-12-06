import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../models/pageinfo_model.dart';
import '../../services/page_info_service.dart';

class PageInfoPage extends StatefulWidget {
  const PageInfoPage({super.key});

  @override
  State<PageInfoPage> createState() => _PageInfoPageState();
}

class _PageInfoPageState extends State<PageInfoPage> {
  List<PageinfoModel> _items = [];
  int currentPage = 1;
  bool isLastPage = false;
  late PageInfoService service;
  String searchQuery = "";

  final List<String> categories = ['qurban', 'kegiatan', 'kajian', 'taksin'];

  @override
  void initState() {
    super.initState();
    _initTokenAndLoadData();
  }

  Future<void> _initTokenAndLoadData() async {
    final token = await SharedPrefs.getToken();
    service = PageInfoService(token!);
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await service.fetchPageInfos(currentPage);
      setState(() {
        _items = data
            .where((e) =>
                e.title.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        isLastPage = data.length < 10;
      });
    } catch (e) {
      if (e.toString().contains('401') || e.toString().contains('500')) {
        AuthHelper.handle401(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memuat ee data: $e')));
      }
    }
  }

  Future<String> uploadImage(PlatformFile file) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/upload-image?token=${service.token}');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${service.token}'
      ..headers['Accept'] = 'application/json';

    if (kIsWeb) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        file.bytes!,
        filename: file.name,
      ));
    } else {
      request.files.add(await http.MultipartFile.fromPath('image', file.path!));
    }

    final response = await request.send();
    //print(request);
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonData = jsonDecode(respStr);
      return jsonData['url'];
    } else {
      throw Exception('Gagal upload (${response.statusCode})');
    }
  }

  void _showForm({PageinfoModel? item}) {
    final title = TextEditingController(text: item?.title ?? '');
    final desc = TextEditingController(text: item?.description ?? '');
    final img = TextEditingController(text: item?.image ?? '');
    final icon = TextEditingController(text: item?.icon ?? '');
    String selectedCategory = item?.category ?? categories.first;
    print(img.text);
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(item == null ? 'Tambah' : 'Edit'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                    controller: title,
                    decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 8),
                TextField(
                  controller: desc,
                  decoration: const InputDecoration(
                      labelText: 'Description', border: OutlineInputBorder()),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 6,
                ),
                TextField(
                    controller: img,
                    decoration: const InputDecoration(labelText: 'Image URL')),
                if (img.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.network(img.text,
                        height: 100,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image)),
                  ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Image"),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );
                    if (result != null) {
                      final url = await uploadImage(result.files.first);
                      setState(() =>
                          img.text = url.replaceFirst('http://', 'http://'));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upload berhasil')));
                    }
                  },
                ),
                TextField(
                    controller: icon,
                    decoration: const InputDecoration(labelText: 'Icon')),
                DropdownButtonFormField(
                  value: selectedCategory,
                  items: categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategory = v!),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newItem = PageinfoModel(
                  id: item?.id ?? 0,
                  title: title.text,
                  description: desc.text,
                  image: img.text,
                  icon: icon.text,
                  category: selectedCategory,
                );

                if (item == null) {
                  await service.create(newItem);
                } else {
                  await service.update(item.id!, newItem);
                }
                Navigator.pop(context);
                await _loadData();
              },
              child: const Text('Simpan'),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal')),
          ],
        ),
      ),
    );
  }

  void _delete(int id) async {
    await service.delete(id);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBarCustom(title: 'Menu Page Info CRUD', routeName: '/homepage'),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text('DAFTAR INFORMASI HALAMAN',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  label: const Text(""),
                  onPressed: _loadData,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("New",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  onPressed: () => _showForm(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) {
                searchQuery = val;
                _loadData();
              },
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: _items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.title,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text("Category: ${item.category}",
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                  ]),
                            ),
                            PopupMenuButton(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.red),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Row(children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 6),
                                    Text("Edit")
                                  ]),
                                  onTap: () =>
                                      Future(() => _showForm(item: item)),
                                ),
                                PopupMenuItem(
                                  child: const Row(children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 6),
                                    Text("Delete")
                                  ]),
                                  onTap: () => Future(() => _delete(item.id!)),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (currentPage > 1) {
                      currentPage--;
                      _loadData();
                    }
                  }),
              Text("$currentPage",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (!isLastPage) {
                      currentPage++;
                      _loadData();
                    }
                  }),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
