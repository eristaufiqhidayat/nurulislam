import 'package:flutter/material.dart';
import '../../../models/barang_harga_model.dart';
import '../../../services/barang_harga_service.dart';
import 'harga_form.dart';
import 'harga_table_widget.dart';

class HargaPage extends StatefulWidget {
  const HargaPage({super.key});

  @override
  State<HargaPage> createState() => _HargaPageState();
}

class _HargaPageState extends State<HargaPage> {
  final service = BarangHargaService();
  List<BarangHarga> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      items = await service.fetchAll();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data harga')));
    } finally {
      setState(() => loading = false);
    }
  }

  void showForm({BarangHarga? item}) {
    showDialog(
      context: context,
      builder: (_) => HargaForm(
        item: item,
        onSubmit: (data) async {
          if (item == null) {
            await service.create(data);
          } else {
            await service.update(data);
          }
          loadData();
        },
      ),
    );
  }

  Future<void> deleteItem(int id) async {
    await service.delete(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Harga Barang'),
        backgroundColor: Colors.green.shade700,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HargaTableWidget(
                items: items,
                onEdit: (item) => showForm(item: item),
                onDelete: deleteItem,
              ),
            ),
    );
  }
}
