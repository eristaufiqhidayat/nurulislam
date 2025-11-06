import 'package:flutter/material.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../../models/pembeli_model.dart';
import '../../services/pembeli_service.dart';
import 'pembeli_form_dialog.dart';
import 'pembeli_table_widget.dart';

class PembeliPage extends StatefulWidget {
  const PembeliPage({super.key});

  @override
  State<PembeliPage> createState() => _PembeliPageState();
}

class _PembeliPageState extends State<PembeliPage> {
  List<PembeliModel> _items = [];
  int currentPage = 1;
  bool isLastPage = false;
  late PembeliService service;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _initTokenAndLoadData();
  }

  Future<void> _initTokenAndLoadData() async {
    final token = await SharedPrefs.getToken();
    service = PembeliService(token!);
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await service.fetchPembelis(currentPage);
      setState(() {
        _items = data
            .where(
                (e) => e.nama.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        isLastPage = data.length < 10;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
  }

  void _delete(int id) async {
    await service.delete(id);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBarCustom(title: 'Data Pembeli', routeName: '/homepage'),
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
              'DAFTAR PEMBELI',
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
                    onPressed: () => showPembeliFormDialog(
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
                  hintText: "Cari pembeli...",
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
            Expanded(
              child: PembeliTableWidget(
                items: _items,
                onEdit: (item) {
                  Future.delayed(const Duration(milliseconds: 150), () {
                    showPembeliFormDialog(
                      context: context,
                      service: service,
                      item: item,
                      onSaveSuccess: _loadData,
                    );
                  });
                },
                onDelete: (id) => _delete(id),
              ),
            ),
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
