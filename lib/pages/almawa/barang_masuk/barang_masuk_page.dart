import 'package:flutter/material.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../../../services/barang_service.dart';
import '../../../services/barang_masuk_service.dart';
import 'barang_masuk_form_dialog.dart';

class BarangMasukPage extends StatefulWidget {
  const BarangMasukPage({super.key});

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  late BarangMasukService barangMasukService;
  late BarangService barangService;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final token = await SharedPrefs.getToken();
    barangMasukService = BarangMasukService(token!);
    barangService = BarangService(token);
  }

  void _openForm() {
    showBarangMasukFormDialog(
      context: context,
      service: barangMasukService,
      barangService: barangService,
      onSaveSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data barang masuk berhasil disimpan')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang Masuk')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("Tambah Barang Masuk"),
          onPressed: _openForm,
        ),
      ),
    );
  }
}
