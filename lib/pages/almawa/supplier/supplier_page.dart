import 'package:flutter/material.dart';
import 'package:nurulislam/models/supplier_model.dart';
import 'package:nurulislam/pages/almawa/supplier/supplier_form_dialog.dart';
import 'package:nurulislam/pages/almawa/supplier/supplier_table_widget.dart';
import 'package:nurulislam/services/supplier_service.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  late SupplierService service;
  // ignore: unused_field
  late Future<List<SupplierModel>> _futureSuppliers;
  List<SupplierModel> _items = [];
  int currentPage = 1;
  bool isLastPage = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    // 🔥 Inisialisasi service wajib!
    service = SupplierService();
    // 🔥 Load data pertama kali
    _futureSuppliers = service.fetch();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await service.fetch();
      //print('Loaded supplier data: ${data} items');

      setState(() {
        _items = data.toList();
        isLastPage = data.length < 10;
      });
    } catch (e) {
      if (e.toString().contains('401')) {
        AuthHelper.handle401(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memuat ee data: $e')));
      }
    }
  }

  void _delete(int id) async {
    await service.delete(id);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Data Supplier', routeName: '/homepage'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFE8F5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'DATA SUPPLIER',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text(""),
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("New"),
                    onPressed: () => showFormDialog(
                      context: context,
                      service: service,
                      onSaveSuccess: _loadData,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  hintText: "Cari barang...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (val) {
                  searchQuery = val;
                  _loadData();
                },
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Widget tabel
            Expanded(
              child: TableWidget(
                items: _items,
                onEdit: (item) {
                  Future.delayed(const Duration(milliseconds: 150), () {
                    showFormDialog(
                      context: context,
                      service: service,
                      item: item, // ✅ kirim data item ke dialog
                      onSaveSuccess: _loadData,
                    );
                  });
                },
                onDelete: (id) => _delete(id),
              ),
            ),

            // 🔹 Pagination
            Container(
              color: Colors.green[200],
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.green),
                    onPressed: () {
                      if (currentPage > 1) {
                        currentPage--;
                        _loadData();
                      }
                    },
                  ),
                  Text(
                    "$currentPage",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.green),
                    onPressed: () {
                      if (!isLastPage) {
                        currentPage++;
                        _loadData();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
