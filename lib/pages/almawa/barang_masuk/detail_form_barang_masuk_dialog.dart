import 'package:flutter/material.dart';
import 'package:nurulislam/models/barang_masuk_model.dart';
import 'package:nurulislam/models/barang_model.dart';
//import 'package:nurulislam/models/detail_penjualan_model.dart';
import '../../../services/barang_service.dart';
import 'package:nurulislam/services/barang_harga_service.dart';

class DetailFormBarangMasukDialog extends StatefulWidget {
  final BarangMasukModel? initial;
  final void Function(Map<String, dynamic>) onSubmit;
  const DetailFormBarangMasukDialog({
    super.key,
    this.initial,
    required this.onSubmit,
  });

  @override
  State<DetailFormBarangMasukDialog> createState() =>
      _DetailFormBarangMasukDialogState();
}

class _DetailFormBarangMasukDialogState
    extends State<DetailFormBarangMasukDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hargaBeliController = TextEditingController();
  int? barangId;
  int? supplierId;
  int jumlah = 0;
  double hargaBeli = 0;
  String supplier = '';
  DateTime tanggalMasuk = DateTime.now();
  List<BarangModel> barangList = [];
  @override
  void initState() {
    super.initState();
    _loadBarang();

    if (widget.initial != null) {
      final i = widget.initial!;
      barangId = i.barangId;
      jumlah = i.jumlah;
      hargaBeli = i.hargaBeli;
      supplier = i.supplier!;
      tanggalMasuk = i.tglMasuk;
      _hargaBeliController.text = hargaBeli.toStringAsFixed(0);
    }
  }

  Future<void> _loadBarang() async {
    final barangService = BarangService();
    barangList = await barangService.fetchBarangs(1);
    setState(() {});
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalMasuk,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggalMasuk = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.initial == null ? 'Tambah Pembelian' : 'Edit Pembelian'),
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
                      value: b.id,
                      child: Text(b.namaBarang),
                    );
                  }).toList(),
                  onChanged: (val) async {
                    setState(() {
                      barangId = val;
                    });

                    if (val != null) {
                      // Ambil harga terbaru berdasarkan barang terpilih
                      final barangHargaService = BarangHargaService();

                      final hargaResponse = await barangHargaService.getHarga(
                        barangId: val,
                        tanggal: DateTime.now().toIso8601String(),
                      );

                      // Misal hasilnya punya properti harga_beli
                      setState(() {
                        hargaBeli = hargaResponse.hargaBeli;
                        _hargaBeliController.text =
                            hargaBeli.toStringAsFixed(0);
                      });
                    }
                  },
                  validator: (val) => val == null ? 'Pilih barang' : null,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  initialValue: jumlah == 0 ? '' : jumlah.toString(),
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => jumlah = int.tryParse(v) ?? 0,
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _hargaBeliController,
                  decoration: const InputDecoration(labelText: 'Harga Beli'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => hargaBeli = double.tryParse(v) ?? 0,
                ),
                const SizedBox(height: 10),

                // ✅ Tanggal masuk (dropdown date picker)
                InkWell(
                  onTap: _pilihTanggal,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Masuk',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${tanggalMasuk.toLocal()}".split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.calendar_today,
                            color: Colors.blueGrey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit({
                'barang_id': barangId,
                'jumlah': jumlah,
                'harga_beli': hargaBeli,
                'supplier': supplier,
                'tanggal_masuk':
                    tanggalMasuk.toIso8601String(), // ✅ sesuaikan ke Laravel
              });
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
