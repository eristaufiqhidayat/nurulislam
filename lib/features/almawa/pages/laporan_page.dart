import 'package:flutter/material.dart';
import 'package:nurulislam/features/almawa/services/almawa_service.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  final repo = AlmawaService();
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
      endDrawer: const MobileDrawer(),
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
