import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../../models/barang_masuk_model.dart';
import '../../../services/barang_masuk_service.dart';
import 'barang_masuk_form_dialog.dart';
import 'barang_masuk_table_widget.dart';

class BarangMasukPage extends StatefulWidget {
  const BarangMasukPage({super.key});

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  List<BarangMasukModel> _items = [];
  int currentPage = 1;
  bool isLastPage = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await BarangMasukService.fetchAll();

      setState(() {
        _items = data
            .where((e) =>
                e.namaBarang.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        isLastPage = data.length < 10; // optional kalau nanti pakai pagination
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  void _delete(int id) async {
    final success = await BarangMasukService.delete(id);
    if (success) _loadData();
  }

  void _showForm([BarangMasukModel? item]) {
    showDialog(
      context: context,
      builder: (_) => BarangMasukFormDialog(
        item: item,
        onSubmit: (data) async {
          bool success = item == null
              ? await BarangMasukService.create(data)
              : await BarangMasukService.update(item.id, data);
          if (success) _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBarCustom(
        title: 'Data Pembelian Barang',
        routeName: '/homepage',
      ),
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
              'DAFTAR PEMBELIAN BARANG',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Tombol refresh & tambah
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("New"),
                    onPressed: () => _showForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Kolom pencarian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  hintText: "Cari nama barang...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    searchQuery = val;
                  });
                  _loadData();
                },
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 List card barang masuk
            Expanded(
              child: BarangMasukTableWidget(
                data: _items,
                onEdit: (item) {
                  Future.delayed(const Duration(milliseconds: 150), () {
                    _showForm(item);
                  });
                },
                onDelete: (id) => _delete(id),
              ),
            ),

            // 🔹 Pagination bawah
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
                      color: Colors.green,
                    ),
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
