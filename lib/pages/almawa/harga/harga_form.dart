import 'package:flutter/material.dart';
import '../../../models/barang_harga_model.dart';
import '../../../models/barang_model.dart';
import '../../../services/barang_service.dart';

class HargaForm extends StatefulWidget {
  final BarangHarga? item;
  final Function(BarangHarga) onSubmit;

  const HargaForm({this.item, required this.onSubmit});

  @override
  State<HargaForm> createState() => _HargaFormState();
}

class _HargaFormState extends State<HargaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController tanggalCtrl;
  late TextEditingController hargaBeliCtrl;
  late TextEditingController hargaJualCtrl;

  List<BarangModel> barangs = [];
  int? selectedBarangId;
  bool loadingBarang = true;

  @override
  void initState() {
    super.initState();
    tanggalCtrl = TextEditingController(text: widget.item?.tanggal ?? '');
    hargaBeliCtrl =
        TextEditingController(text: widget.item?.hargaBeli.toString() ?? '');
    hargaJualCtrl =
        TextEditingController(text: widget.item?.hargaJual.toString() ?? '');
    selectedBarangId = widget.item?.barangId;
    _loadBarangList();
  }

  Future<void> _loadBarangList() async {
    try {
      final data = await BarangService().fetchBarangs(1);
      setState(() {
        barangs = data;
        loadingBarang = false;
      });
    } catch (e) {
      print('❌ Gagal memuat barang: $e');
      setState(() => loadingBarang = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item == null ? 'Tambah Harga' : 'Edit Harga'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔽 Dropdown Barang
              loadingBarang
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<int>(
                      value: selectedBarangId,
                      decoration:
                          const InputDecoration(labelText: 'Pilih Barang'),
                      items: barangs.map((b) {
                        return DropdownMenuItem<int>(
                          value: b.id,
                          child: Text('${b.namaBarang} (ID: ${b.id})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBarangId = value;
                        });
                      },
                      validator: (v) =>
                          v == null ? 'Barang harus dipilih' : null,
                    ),

              TextFormField(
                controller: tanggalCtrl,
                decoration: const InputDecoration(
                    labelText: 'Tanggal Berlaku (YYYY-MM-DD)'),
                validator: (v) =>
                    v!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: hargaBeliCtrl,
                decoration: const InputDecoration(labelText: 'Harga Beli'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? 'Harga Beli tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: hargaJualCtrl,
                decoration: const InputDecoration(labelText: 'Harga Jual'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? 'Harga Jual tidak boleh kosong' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Batal'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Simpan'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final data = BarangHarga(
                id: widget.item?.id,
                barangId: selectedBarangId!,
                tanggal: tanggalCtrl.text,
                hargaBeli: double.parse(hargaBeliCtrl.text),
                hargaJual: double.parse(hargaJualCtrl.text),
              );
              widget.onSubmit(data);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
