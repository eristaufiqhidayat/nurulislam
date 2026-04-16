// ignore_for_file: avoid_print, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../models/barang_model.dart';
import '../../services/barang_service.dart';

Future<void> showBarangFormDialog({
  required BuildContext context,
  required BarangService service,
  required List<String> kategoriList,
  BarangModel? item,
  required Future<void> Function() onSaveSuccess,
}) async {
  // ✅ Controller dibuat sekali saja di luar StatefulBuilder
  final nama = TextEditingController(text: item?.namaBarang ?? '');
  final satuan = TextEditingController(text: item?.satuan ?? '');
  final hargaBeli =
      TextEditingController(text: item?.hargaBeli.toString() ?? '');
  final hargaJual =
      TextEditingController(text: item?.hargaJual.toString() ?? '');
  final stok = TextEditingController(text: item?.stok.toString() ?? '');

  String selectedKategori = item?.kategori ?? kategoriList.first;
  print('🧾 Data diterima di form: ${item?.namaBarang} | ${item?.kategori}');
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.green[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              item == null ? 'Tambah Barang' : 'Edit Barang',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                TextField(
                  controller: nama,
                  decoration: const InputDecoration(
                    labelText: 'Nama Barang',
                    prefixIcon: Icon(Icons.shopping_bag, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: kategoriList.contains(selectedKategori)
                      ? selectedKategori
                      : null,
                  items: kategoriList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(
                      () => selectedKategori = v ?? kategoriList.first),
                  decoration: const InputDecoration(
                    labelText: 'Kategori Barang',
                    prefixIcon: Icon(Icons.category, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: satuan,
                  decoration: const InputDecoration(
                    labelText: 'Satuan (pcs, kg, dll)',
                    prefixIcon: Icon(Icons.scale, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hargaBeli,
                  decoration: const InputDecoration(
                    labelText: 'Harga Beli',
                    prefixIcon:
                        Icon(Icons.monetization_on, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hargaJual,
                  decoration: const InputDecoration(
                    labelText: 'Harga Jual',
                    prefixIcon: Icon(Icons.sell, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stok,
                  decoration: const InputDecoration(
                    labelText: 'Stok',
                    prefixIcon: Icon(Icons.storage, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.save),
            label: const Text("Simpan",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () async {
              final newItem = BarangModel(
                id: item?.id,
                namaBarang: nama.text,
                kategori: selectedKategori,
                satuan: satuan.text,
                hargaBeli: double.tryParse(hargaBeli.text) ?? 0,
                hargaJual: double.tryParse(hargaJual.text) ?? 0,
                stok: int.tryParse(stok.text) ?? 0,
              );
              if (item == null) {
                await service.create(newItem);
              } else {
                await service.update(item.id!, newItem);
              }

              Navigator.pop(context);
              await onSaveSuccess();
            },
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.cancel),
            label: const Text("Batal",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
