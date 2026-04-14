import 'package:flutter/material.dart';
import '../../services/almawa_service.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final repo = AlmawaService();
  List stokHabis = [];

  @override
  void initState() {
    super.initState();
    cek();
  }

  Future<void> cek() async {
    final data = await repo.cekStok();
    setState(() => stokHabis = data['data'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cek Stok Habis')),
      body: stokHabis.isEmpty
          ? const Center(child: Text('Semua stok aman ✅'))
          : ListView.builder(
              itemCount: stokHabis.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(stokHabis[i]['nama_barang']),
                subtitle: Text('Stok: ${stokHabis[i]['stok']}'),
              ),
            ),
    );
  }
}
