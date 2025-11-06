import 'package:flutter/material.dart';
import '../../../models/barang_masuk_model.dart';
import '../../../services/barang_masuk_service.dart';
import 'barang_masuk_form_dialog.dart';
import 'barang_masuk_table_widget.dart';
//import '../../../widgets/appbar_widget.dart';

class BarangMasukPage extends StatefulWidget {
  const BarangMasukPage({super.key});

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  late Future<List<BarangMasukModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = BarangMasukService.fetchAll();
  }

  void _refreshData() {
    setState(() {
      futureData = BarangMasukService.fetchAll();
    });
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
          if (success) _refreshData();
        },
      ),
    );
  }

  void _delete(int id) async {
    await BarangMasukService.delete(id);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Pembelian Barang')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<BarangMasukModel>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return BarangMasukTableWidget(
            data: data,
            onEdit: (item) => _showForm(item),
            onDelete: (id) => _delete(id),
          );
        },
      ),
    );
  }
}
