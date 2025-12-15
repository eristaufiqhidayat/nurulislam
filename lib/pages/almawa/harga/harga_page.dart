import 'package:flutter/material.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
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
      if (e.toString().contains('401') || e.toString().contains('500')) {
        AuthHelper.handle401(context);
      } else {
        print('❌ Gagal memuat data: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memuat ee data: $e')));
      }
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
      appBar: AppBarCustom(
        title: "Harga Barang",
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => showForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daftar Harga',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: HargaTableWidget(
                      items: items,
                      onEdit: (item) => showForm(item: item),
                      onDelete: deleteItem,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
