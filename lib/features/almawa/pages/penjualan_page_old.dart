import 'package:flutter/material.dart';
import '../services/almawa_service.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  final repo = AlmawaService();
  final pembeliIdController = TextEditingController();
  final barangIdController = TextEditingController();
  final jumlahController = TextEditingController();

  List<Map<String, dynamic>> barangList = [];

  void addBarang() {
    barangList.add({
      'id': int.parse(barangIdController.text),
      'jumlah': int.parse(jumlahController.text),
    });
    barangIdController.clear();
    jumlahController.clear();
    setState(() {});
  }

  Future<void> submit() async {
    try {
      final res = await repo.tambahPenjualan(
        int.parse(pembeliIdController.text),
        barangList,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Penjualan berhasil')),
      );
      barangList.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: pembeliIdController,
                decoration: const InputDecoration(labelText: 'ID Pembeli')),
            Row(children: [
              Expanded(
                  child: TextField(
                      controller: barangIdController,
                      decoration:
                          const InputDecoration(labelText: 'ID Barang'))),
              const SizedBox(width: 8),
              Expanded(
                  child: TextField(
                      controller: jumlahController,
                      decoration: const InputDecoration(labelText: 'Jumlah'))),
              IconButton(onPressed: addBarang, icon: const Icon(Icons.add)),
            ]),
            Expanded(
              child: ListView.builder(
                itemCount: barangList.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text('Barang ID: ${barangList[i]['id']}'),
                  subtitle: Text('Jumlah: ${barangList[i]['jumlah']}'),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: submit, child: const Text('Simpan Penjualan')),
          ],
        ),
      ),
    );
  }
}
