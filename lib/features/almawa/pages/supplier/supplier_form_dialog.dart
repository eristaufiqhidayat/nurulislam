import 'package:flutter/material.dart';
import '../../../../models/supplier_model.dart';
import '../../../../services/supplier_service.dart';

Future<void> showFormDialog({
  required BuildContext context,
  required SupplierService service,
  SupplierModel? item,
  required Future<void> Function() onSaveSuccess,
}) async {
  // ✅ Controller dibuat sekali saja di luar StatefulBuilder
  final id = TextEditingController(text: item?.id.toString() ?? '');
  final nama = TextEditingController(text: item?.nama ?? '');
  final alamat = TextEditingController(text: item?.alamat ?? '');
  final telp = TextEditingController(text: item?.telp.toString() ?? '');

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
              item == null ? 'Tambah' : 'Edit',
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
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.shopping_bag, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 12),
                TextField(
                  controller: id,
                  decoration: const InputDecoration(
                    labelText: 'id',
                    prefixIcon: Icon(Icons.scale, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: alamat,
                  decoration: const InputDecoration(
                    labelText: 'alamat',
                    prefixIcon: Icon(Icons.scale, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telp,
                  decoration: const InputDecoration(
                    labelText: 'Telp',
                    prefixIcon: Icon(Icons.sell, color: Colors.green),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
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
              final supplier = SupplierModel(
                id: item?.id, // <-- kalau edit ada ID, kalau create null
                nama: nama.text,
                alamat: alamat.text,
                telp: telp.text,
              );
              print('Saving supplier: ${supplier.toJson()}');
              // ignore: unnecessary_null_comparison
              if (item == null) {
                await service.create(supplier);
              } else {
                await service.update(item.id!, supplier);
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
