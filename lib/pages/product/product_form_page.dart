import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/product_model.dart';
import 'package:nurulislam/services/category_service.dart';
import 'package:nurulislam/services/shop_service.dart';
import 'package:nurulislam/widgets/dropdown_search_map.dart';
import '../../services/product_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
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
  File? selectedImage;
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

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      final p = widget.product!;
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

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        requestFullMetadata: false, // ⬅️ FIX HEIC
      );

      if (image == null) return;
      //final fileNameOnly = path.basename(image.path);
      //print('Filename only: $fileNameOnly');
      setState(() {
        selectedImage = File(image.path);
        uploadingImage = true;
      });
      //print('Uploaded image ');
      final filename = await service.uploadImage(selectedImage!);
      //print('Uploaded image filename: $filename');
      setState(() {
        uploadedImageName = filename;
        uploadingImage = false;
      });
    } catch (e) {
      setState(() => uploadingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar')),
      );
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
                fetchData: serviceShop.getShops,
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
                onTap: pickImage,
                child: Container(
                  //width: double.infinity,
                  //height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade50,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildImagePreview(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (uploadedImageName == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Image belum tersedia')),
                          );
                          return;
                        }

                        setState(() => loading = true);

                        if (widget.product == null) {
                          // ✅ CREATE
                          await service.save(
                            shopId: selectedShop!['id'],
                            categoryId: selectedCategory!['id'],
                            name: nameCtrl.text,
                            desc: descCtrl.text,
                            price: double.parse(priceCtrl.text),
                            stock: int.parse(stockCtrl.text),
                            status: selectedStatus!['id'],
                            imageFile: uploadedImageName!,
                          );
                        } else {
                          print("update ${widget.product!.id}");
                          //✅ UPDATE
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
                            imageFile: uploadedImageName!,
                          );
                        }

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

  Widget _imagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.image,
          size: 40,
          color: Colors.green,
        ),
        SizedBox(height: 8),
        Text(
          'Tap to upload image',
          style: TextStyle(color: Colors.green),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    // 1️⃣ Image baru dipilih
    if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    // 2️⃣ Edit mode + image lama ada
    if (uploadedImageName != null && uploadedImageName!.isNotEmpty) {
      return Image.network(
        '$imageBaseUrl$uploadedImageName',
        //fit: BoxFit.cover,
        //width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _imagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
      );
    }

    // 3️⃣ Tidak ada image sama sekali
    return _imagePlaceholder();
  }
}
