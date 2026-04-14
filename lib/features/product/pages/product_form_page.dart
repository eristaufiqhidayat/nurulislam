import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/product_model.dart';
import 'package:nurulislam/services/category_service.dart';
import 'package:nurulislam/services/shop_service.dart';
import 'package:nurulislam/widgets/dropdown_search_map.dart';
import '../../../services/product_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
//import 'dart:io';
import 'dart:typed_data';
//import 'package:flutter/foundation.dart';
//import 'package:path/path.dart' as path;

class ProductFormPage extends StatefulWidget {
  final ProductModel? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final ProductService service = ProductService();
  final CategoryService serviceCategory = CategoryService();
  final ShopService serviceShop = ShopService();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  //File? selectedImage;
  String? uploadedImageName;
  bool uploadingImage = false;
  final imageCtrl = TextEditingController();
  final statusList = [
    {'id': 'active', 'name': 'ACTIVE'},
    {'id': 'inactive', 'name': 'INACTIVE'},
  ];
  Map<String, dynamic>? selectedStatus;
  Map<String, dynamic>? selectedShop;
  Map<String, dynamic>? selectedCategory;
  bool loading = false;
  String imageBaseUrl = '${ApiConstants.baseUrl}/storage/uploads/';
  File? selectedImage; // 📱 Mobile
  Uint8List? webImageBytes; // 🌐 Web
  List<File> mobileImages = []; // 📱
  List<Uint8List> webImages = []; // 🌐
  List<String> uploadedImages = []; // dari server (edit mode)

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final p = widget.product!;
      if (p.imageJson != null && p.imageJson!.isNotEmpty) {
        uploadedImages = p.imageJson!.map((e) => e.toString()).toList();
      }
      nameCtrl.text = p.name;
      descCtrl.text = p.description ?? '';
      priceCtrl.text = p.price.toString();
      stockCtrl.text = p.stock.toString();
      uploadedImageName = p.image; // ⬅️ image lama
      // 🔥 INI KUNCI UTAMA
      //print('shop name ${p.shopName}');
      selectedShop = {
        'id': p.shopId,
        'name': p.shopName, // pastikan ada di model
      };

      selectedCategory = {
        'id': p.categoryId,
        'name': p.categoryName,
      };

      selectedStatus = statusList.firstWhere(
        (e) => e['id'] == p.status,
      );
    }
  }

  Future<XFile> convertHeicToJpg(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 80,
      format: CompressFormat.jpeg,
    );

    return result!;
  }

  Future<void> pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();

    if (images.isEmpty) return;

    if (kIsWeb) {
      final bytesList = await Future.wait(
        images.map((e) => e.readAsBytes()),
      );

      setState(() {
        webImages.addAll(bytesList);
      });
    } else {
      List<File> files = [];

      for (var img in images) {
        File file = File(img.path);

        // 🔥 HANDLE HEIC
        if (img.path.toLowerCase().endsWith('.heic')) {
          final converted = await convertHeicToJpg(file);
          files.add(File(converted.path));
        } else {
          files.add(file);
        }
      }

      setState(() {
        mobileImages.addAll(files);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownSearchMap(
                fetchData: serviceShop.getDropdownShops,
                label: 'Shop',
                idKey: 'id',
                textKey: 'name',
                selectedItem: selectedShop,
                initialId: widget.product?.shopId,
                onChanged: (value) {
                  selectedShop = value;
                  // Handle category selection
                },
              ),
              SizedBox(height: 16),
              DropdownSearchMap(
                fetchData: serviceCategory.getCategories,
                selectedItem: selectedCategory,
                label: 'Category',
                idKey: 'id',
                textKey: 'name',
                initialId: widget.product?.categoryId,
                onChanged: (value) {
                  selectedCategory = value;
                  // Handle category selection
                },
              ),
              SizedBox(height: 24),
              DropdownSearchMap(
                fetchData: () async => statusList,
                selectedItem: selectedStatus,
                label: 'Status',
                idKey: 'id',
                textKey: 'name',
                onChanged: (value) {
                  selectedStatus = value;
                },
              ),
              SizedBox(height: 24),
              TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Product')),
              TextField(
                  controller: descCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Detail Product')),
              TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price')),
              TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stock')),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Product Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: pickImages,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade50,
                  ),
                  child: const Center(
                    child: Text("Tambah Gambar"),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              buildImageGrid(), // 🔥 INI YANG KURANG
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        print({
                          "shop_id": selectedShop?['id'],
                          "category_id": selectedCategory?['id'],
                          "name": nameCtrl.text,
                          "price": priceCtrl.text,
                          "stock": stockCtrl.text,
                          "status": selectedStatus?['id'],
                        });
                        List<String> finalImages = [...uploadedImages];

                        try {
                          if (kIsWeb && webImages.isNotEmpty) {
                            setState(() => uploadingImage = true);

                            final uploaded = await service.uploadMultipleImages(
                              webBytes: webImages,
                            );

                            finalImages.addAll(uploaded);

                            setState(() => uploadingImage = false);
                          } else if (mobileImages.isNotEmpty) {
                            setState(() => uploadingImage = true);

                            final uploaded = await service.uploadMultipleImages(
                              files: mobileImages,
                            );

                            finalImages.addAll(uploaded);

                            setState(() => uploadingImage = false);
                          }
                        } catch (e) {
                          print("ERROR UPLOAD: $e"); // 🔥 WAJIB
                          setState(() => uploadingImage = false);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Upload gagal: $e')),
                          );

                          return; // ⛔ stop di sini
                        }

                        if (widget.product == null && finalImages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Minimal 1 gambar')),
                          );
                          return;
                        }

                        setState(() => loading = true);

                        if (widget.product == null) {
                          print('SIMPAN BARU');
                          await service.save(
                            shopId: selectedShop!['id'],
                            categoryId: selectedCategory!['id'],
                            name: nameCtrl.text,
                            desc: descCtrl.text,
                            price: double.parse(priceCtrl.text),
                            stock: int.parse(stockCtrl.text),
                            status: selectedStatus!['id'],
                            images: finalImages,
                          );
                        } else {
                          await service.update(
                            id: widget.product!.id,
                            shopId:
                                selectedShop?['id'] ?? widget.product!.shopId,
                            categoryId: selectedCategory?['id'] ??
                                widget.product!.categoryId,
                            name: nameCtrl.text,
                            desc: descCtrl.text,
                            price: double.parse(priceCtrl.text),
                            stock: int.parse(stockCtrl.text),
                            status:
                                selectedStatus?['id'] ?? widget.product!.status,
                            images:
                                finalImages, // 🔥 tetap pakai yang lama kalau tidak diganti
                          );
                        }
                        if (uploadingImage)
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: LinearProgressIndicator(),
                          );

                        setState(() => loading = false);
                        Navigator.pop(context);
                      },
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.product == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageGrid() {
    List<Widget> items = [];

    // 🌐 WEB
    if (kIsWeb) {
      items.addAll(webImages.map((bytes) {
        return _imageItem(
          Image.memory(bytes, fit: BoxFit.cover),
          onDelete: () {
            setState(() => webImages.remove(bytes));
          },
        );
      }));
    } else {
      // 📱 MOBILE
      items.addAll(mobileImages.map((file) {
        return _imageItem(
          Image.file(file, fit: BoxFit.cover),
          onDelete: () {
            setState(() => mobileImages.remove(file));
          },
        );
      }));
    }

    // 🖼️ IMAGE LAMA (EDIT MODE)
    items.addAll(uploadedImages.map((img) {
      return _imageItem(
        Image.network('$imageBaseUrl$img', fit: BoxFit.cover),
        onDelete: () {
          setState(() => uploadedImages.remove(img));
        },
      );
    }));

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      physics: const NeverScrollableScrollPhysics(),
      children: items,
    );
  }

  Widget _imageItem(Widget image, {required VoidCallback onDelete}) {
    return Stack(
      children: [
        Positioned.fill(child: image),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
