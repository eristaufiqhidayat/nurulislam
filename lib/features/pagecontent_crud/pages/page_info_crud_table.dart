// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../page_info/models/pageinfo_model.dart';
import '../../page_info/services/page_info_service.dart';

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
        _items = data;
        isLastPage = data.length < 10;
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: $e')),
        );
      }
    }
  }

  /// Upload image ke Laravel API (Mobile & Web)
  Future<String> uploadImage(PlatformFile file) async {
    try {
      final uri = Uri.parse(
          '${ApiConstants.baseUrl}/api/upload-image?token=${service.token}');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer ${service.token}'
        ..headers['Accept'] = 'application/json';

      if (kIsWeb) {
        // Pastikan bytes tidak null
        Uint8List fileBytes = file.bytes ?? Uint8List(0);
        if (fileBytes.isEmpty) {
          throw Exception(
              'File bytes kosong, pastikan file dipilih dengan benar.');
        }
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            fileBytes,
            filename: file.name,
          ),
        );
      } else {
        if (file.path == null) {
          throw Exception('File path tidak ditemukan.');
        }
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            file.path!,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      } else {
        throw Exception(
          'Upload gagal: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat upload: $e');
    }
  }

  Future<String> uploadImage2(PlatformFile file) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/upload-image?token=${service.token}');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${service.token}'
      ..headers['Accept'] = 'application/json';

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image', // nama field sesuai Laravel
          file.bytes!,
          filename: file.name,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          file.path!,
        ),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonData = jsonDecode(respStr);
      return jsonData['url'];
    } else {
      throw Exception('Gagal upload image (${response.statusCode})');
    }
  }

  void _showForm({PageinfoModel? item}) {
    final title = TextEditingController(text: item?.title ?? '');
    final desc = TextEditingController(text: item?.description ?? '');
    final img = TextEditingController(text: item?.image ?? '');
    final icon = TextEditingController(text: item?.icon ?? '');
    String selectedCategory = item?.category ?? categories.first;

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
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: desc,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 3, // tinggi minimal
                      maxLines: 6, //
                      onChanged: (_) => setState(() {}),
                    )),
                // Input URL image
                TextField(
                    controller: img,
                    decoration: const InputDecoration(labelText: 'Image URL')),
                // Preview image
                if (img.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Image.network(
                      ApiConstants.getFullImageUrl(img.text),
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),

                // Tombol upload
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Image"),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      withData: true,
                    );
                    if (result != null && result.files.isNotEmpty) {
                      final pickedFile = result.files.first;

                      if (pickedFile.bytes == null ||
                          pickedFile.bytes!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('File kosong atau gagal dibaca')),
                        );
                        return;
                      }

                      try {
                        print(
                            'Selected file: ${pickedFile.name}, size: ${pickedFile.bytes!.length}');
                        final url = await uploadImage(pickedFile);
                        final secureUrl =
                            url.replaceFirst('http://', 'https://');
                        if (context.mounted) {
                          setState(() => img.text = secureUrl);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Upload berhasil')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Upload gagal: $e')),
                          );
                        }
                      }
                    }
                  },
                ),

                TextField(
                    controller: icon,
                    decoration: const InputDecoration(labelText: 'Icon')),
                DropdownButtonFormField(
                  initialValue: selectedCategory,
                  items: categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selectedCategory = value!),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (title.text.isEmpty || desc.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field wajib diisi')),
                  );
                  return;
                }

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

                if (context.mounted) Navigator.pop(context);
                await _loadData();
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Menu Page Info CRUD',
        routeName: '/homepage',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'DAFTAR INFORMASI HALAMAN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _items.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(Colors.green),
                          headingTextStyle:
                              const TextStyle(color: Colors.white),
                          dataRowMinHeight: 40, // tinggi minimal
                          dataRowMaxHeight:
                              double.infinity, // biar bisa tinggi sesuai wrap
                          columns: [
                            const DataColumn(label: Text('No')),
                            const DataColumn(label: Text('Title')),
                            if (!isSmallScreen) ...[
                              const DataColumn(label: Text('Description')),
                              const DataColumn(label: Text('Image')),
                              const DataColumn(label: Text('Icon')),
                              const DataColumn(label: Text('Category')),
                            ],
                            const DataColumn(label: Text('Aksi')),
                          ],
                          rows: _items.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            int maxLength = 50;
                            String hasil = item.description.length > maxLength
                                ? item.description.substring(0, maxLength)
                                : item.description;
                            return DataRow(cells: [
                              DataCell(Text(
                                  '${(currentPage - 1) * 10 + index + 1}')),

                              // Title wrap
                              DataCell(
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: isSmallScreen ? 120 : 200),
                                  child: Text(
                                    item.title,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),

                              if (!isSmallScreen) ...[
                                DataCell(SizedBox(
                                  width: 100,
                                  child: Text(hasil,
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                )),
                                DataCell(SizedBox(
                                  width: 250,
                                  child: Text(item.image,
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                )),
                                DataCell(SizedBox(
                                  width: 50,
                                  child: Text(item.icon,
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                )),
                                DataCell(SizedBox(
                                  width: 80,
                                  child: Text(item.category ?? '',
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                )),
                              ],

                              // Aksi
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => _showForm(item: item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _delete(item.id!),
                                  ),
                                ],
                              )),
                            ]);
                          }).toList(),
                        ),
                  const SizedBox(height: 12),
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
                        },
                      ),
                      Text('Halaman $currentPage'),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          if (!isLastPage) {
                            currentPage++;
                            _loadData();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
