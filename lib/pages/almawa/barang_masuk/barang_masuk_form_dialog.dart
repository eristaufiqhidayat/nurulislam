import 'package:flutter/material.dart';
import '../../../models/barang_model.dart';
import '../../../models/barang_masuk_model.dart';
import '../../../services/barang_service.dart';

class BarangMasukFormDialog extends StatefulWidget {
  final BarangMasukModel? item;
  final void Function(Map<String, dynamic>) onSubmit;

  const BarangMasukFormDialog({super.key, this.item, required this.onSubmit});

  @override
  State<BarangMasukFormDialog> createState() => _BarangMasukFormDialogState();
}

class _BarangMasukFormDialogState extends State<BarangMasukFormDialog> {
  final _formKey = GlobalKey<FormState>();
  int? barangId;
  int jumlah = 0;
  double hargaBeli = 0;
  String supplier = '';
  DateTime tglMasuk = DateTime.now();
  List<BarangModel> barangList = [];

  @override
  void initState() {
    super.initState();
    _loadBarang();
    if (widget.item != null) {
      final i = widget.item!;
      barangId = i.barangId;
      jumlah = i.jumlah;
      hargaBeli = i.hargaBeli;
      supplier = i.supplier;
      tglMasuk = i.tglMasuk;
    }
  }

  Future<void> _loadBarang() async {
    final barangService = BarangService(); // ✅ buat instance
    barangList = await barangService.fetchBarangs(1); // ✅ panggil method
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Tambah Pembelian' : 'Edit Pembelian'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: barangId,
                  decoration: const InputDecoration(labelText: 'Barang'),
                  items: barangList.map((b) {
                    return DropdownMenuItem(
                        value: b.id, child: Text(b.namaBarang));
                  }).toList(),
                  onChanged: (val) => setState(() => barangId = val),
                  validator: (val) => val == null ? 'Pilih barang' : null,
                ),
                TextFormField(
                  initialValue: jumlah.toString(),
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => jumlah = int.tryParse(v) ?? 0,
                ),
                TextFormField(
                  initialValue: hargaBeli.toString(),
                  decoration: const InputDecoration(labelText: 'Harga Beli'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => hargaBeli = double.tryParse(v) ?? 0,
                ),
                TextFormField(
                  initialValue: supplier,
                  decoration: const InputDecoration(labelText: 'Supplier'),
                  onChanged: (v) => supplier = v,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit({
                'barang_id': barangId,
                'jumlah': jumlah,
                'harga_beli': hargaBeli,
                'supplier': supplier,
                'tgl_masuk': tglMasuk.toIso8601String(),
              });
              Navigator.pop(context);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
