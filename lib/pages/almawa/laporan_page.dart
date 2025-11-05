import 'package:flutter/material.dart';
import '../../repositories/transaksi_repository.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final repo = TransaksiRepository();
  List laporan = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final data = await repo.getLaporan();
    setState(() => laporan = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Penjualan')),
      body: ListView.builder(
        itemCount: laporan.length,
        itemBuilder: (_, i) {
          final item = laporan[i];
          return Card(
            child: ListTile(
              title:
                  Text('Tanggal: ${item['tanggal']} | Total: ${item['total']}'),
              subtitle: Text('Margin: ${item['margin_total']}'),
            ),
          );
        },
      ),
    );
  }
}
