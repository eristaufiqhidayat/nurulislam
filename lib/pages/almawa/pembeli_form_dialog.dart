import 'package:flutter/material.dart';
import '../../models/pembeli_model.dart';
import '../../services/pembeli_service.dart';

void showPembeliFormDialog({
  required BuildContext context,
  required PembeliService service,
  required VoidCallback onSaveSuccess,
  PembeliModel? item,
}) {
  final TextEditingController namaController =
      TextEditingController(text: item?.nama ?? '');
  final TextEditingController alamatController =
      TextEditingController(text: item?.alamat ?? '');
  final TextEditingController noTeleponController =
      TextEditingController(text: item?.noTelepon ?? '');

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(item == null ? 'Tambah Pembeli' : 'Edit Pembeli'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noTeleponController,
                decoration: const InputDecoration(labelText: 'No Telepon'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () async {
              try {
                final newItem = PembeliModel(
                  id: item?.id ?? 0,
                  nama: namaController.text,
                  alamat: alamatController.text,
                  noTelepon: noTeleponController.text,
                  createdAt: item?.createdAt ?? DateTime.now(),
                );

                if (item == null) {
                  await service.create(newItem);
                } else {
                  await service.update(item.id, newItem);
                }

                onSaveSuccess();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menyimpan data: $e')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
