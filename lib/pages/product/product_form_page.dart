import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nurulislam/services/category_service.dart';
import 'package:nurulislam/services/shop_service.dart';
import 'package:nurulislam/widgets/dropdown_search_map.dart';
import '../../services/product_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

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

      setState(() {
        selectedImage = File(image.path);
        uploadingImage = true;
      });

      final filename = await service.uploadImage(selectedImage!);

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
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownSearchMap(
              fetchData: serviceShop.getShops,
              label: 'Shop',
              idKey: 'id',
              textKey: 'name',
              onChanged: (value) {
                selectedShop = value;
                // Handle category selection
              },
            ),
            SizedBox(height: 16),
            DropdownSearchMap(
              fetchData: serviceCategory.getCategories,
              label: 'Category',
              idKey: 'id',
              textKey: 'name',
              onChanged: (value) {
                selectedCategory = value;
                // Handle category selection
              },
            ),
            SizedBox(height: 24),
            DropdownSearchMap(
              fetchData: () async => statusList,
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
                decoration: const InputDecoration(labelText: 'Detail Product')),
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
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.shade50,
                ),
                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image, size: 40, color: Colors.green),
                          SizedBox(height: 8),
                          Text('Tap to upload image'),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      if (selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image wajib diupload')),
                        );
                        return;
                      }

                      setState(() => loading = true);

                      await service.save(
                        shopId: selectedShop!['id'],
                        categoryId: selectedCategory!['id'],
                        name: nameCtrl.text,
                        desc: descCtrl.text,
                        price: double.parse(priceCtrl.text),
                        stock: int.parse(stockCtrl.text),
                        status: selectedStatus!['id'],
                        imageFile: selectedImage, // ⬅️ tambah ini
                      );

                      setState(() => loading = false);
                      Navigator.pop(context);
                    },
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
