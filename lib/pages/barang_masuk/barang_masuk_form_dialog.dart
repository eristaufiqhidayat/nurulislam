import 'package:flutter/material.dart';
import '../../models/barang_masuk_model.dart';
import '../../models/barang_model.dart';
import '../../services/barang_masuk_service.dart';
import '../../services/barang_service.dart';

void showBarangMasukFormDialog({
  required BuildContext context,
  required BarangMasukService service,
  required BarangService barangService,
  required VoidCallback onSaveSuccess,
}) {
  final TextEditingController jumlahController = TextEditingController();
  final TextEditingController hargaBeliController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  BarangModel? selectedBarang;
  DateTime? selectedDate;

  Future<void> pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      selectedDate = picked;
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FutureBuilder<List<BarangModel>>(
            future: barangService.fetchBarangs(1),
            builder: (context, snapshot) {
              final barangList = snapshot.data ?? [];

              return AlertDialog(
                title: const Text('Tambah Barang Masuk'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown Barang
                      DropdownButtonFormField<int>(
                        value: selectedBarang?.id,
                        decoration: const InputDecoration(
                          labelText: 'Pilih Barang',
                          border: OutlineInputBorder(),
                        ),
                        items: barangList.map((b) {
                          return DropdownMenuItem<int>(
                            value: b.id, // ✅ hanya kirim ID
                            child: Text(b.namaBarang),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedBarang =
                                barangList.firstWhere((b) => b.id == val);
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      // Jumlah
                      TextField(
                        controller: jumlahController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Harga Beli
                      TextField(
                        controller: hargaBeliController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Harga Beli',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Supplier
                      TextField(
                        controller: supplierController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tanggal Masuk
                      InkWell(
                        onTap: () async {
                          await pilihTanggal();
                          setState(() {});
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Tanggal Masuk',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            selectedDate == null
                                ? 'Pilih tanggal'
                                : selectedDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                          ),
                        ),
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
                      if (selectedBarang == null || selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Pilih barang dan tanggal masuk')),
                        );
                        return;
                      }

                      try {
                        final newItem = BarangMasukModel(
                          id: 0,
                          barangId: selectedBarang!.id!,
                          jumlah: int.parse(jumlahController.text),
                          tglMasuk: selectedDate!,
                          hargaBeli:
                              double.parse(hargaBeliController.text.trim()),
                          supplier: supplierController.text.trim(),
                        );

                        await service.create(newItem);
                        onSaveSuccess();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal menyimpan: $e')),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}
