import 'package:flutter/material.dart';
import '../../repositories/transaksi_repository.dart';

class BarangMasukPage extends StatefulWidget {
  const BarangMasukPage({super.key});

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  final repo = TransaksiRepository();
  final barangIdController = TextEditingController();
  final jumlahController = TextEditingController();

  Future<void> submit() async {
    try {
      final res = await repo.tambahBarangMasuk(
        int.parse(barangIdController.text),
        int.parse(jumlahController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Berhasil')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Barang Masuk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: barangIdController,
                decoration: const InputDecoration(labelText: 'ID Barang')),
            TextField(
                controller: jumlahController,
                decoration: const InputDecoration(labelText: 'Jumlah')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submit, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
