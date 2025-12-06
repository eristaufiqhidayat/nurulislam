import 'package:flutter/material.dart';
import 'package:nurulislam/utils/auth_helper.dart';
//import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../../models/barang_model.dart';
import '../../../services/barang_service.dart';
import 'barang_table_widget.dart';
import 'barang_form_dialog.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<BarangModel> _items = [];
  int currentPage = 1;
  bool isLastPage = false;
  late BarangService service;
  String searchQuery = "";
  bool isLoading = false;

  final List<String> kategoriList = [
    'Beras',
    'Minyak',
    'Sembako Lainnya',
    'Almawa'
  ];

  @override
  void initState() {
    super.initState();
    _initTokenAndLoadData();
  }

  Future<void> _initTokenAndLoadData() async {
    service = BarangService();
    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final data = await service.fetchBarangs(currentPage);
      setState(() {
        _items = data
            .where((e) =>
                e.namaBarang.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        isLastPage = data.length < 10;
      });
    } catch (e) {
      if (e.toString().contains('401')) {
        AuthHelper.handle401(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal test memuat data: $e')));
      }
    }
    setState(() => isLoading = false);
  }

  void _delete(int id) async {
    await service.delete(id);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBarCustom(title: 'Data Barang', routeName: '/homepage'),
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
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            const Text(
              'DAFTAR BARANG',
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
                    onPressed: () => showBarangFormDialog(
                      context: context,
                      service: service,
                      kategoriList: kategoriList,
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
              child: BarangTableWidget(
                items: _items,
                onEdit: (item) {
                  Future.delayed(const Duration(milliseconds: 150), () {
                    showBarangFormDialog(
                      context: context,
                      service: service,
                      kategoriList: kategoriList,
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
