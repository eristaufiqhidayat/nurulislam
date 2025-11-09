import 'package:flutter/material.dart';
import '../../../models/barang_harga_model.dart';

class HargaForm extends StatefulWidget {
  final BarangHarga? item;
  final Function(BarangHarga) onSubmit;

  const HargaForm({this.item, required this.onSubmit});

  @override
  State<HargaForm> createState() => _HargaFormState();
}

class _HargaFormState extends State<HargaForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController barangIdCtrl;
  late TextEditingController tanggalCtrl;
  late TextEditingController hargaBeliCtrl;
  late TextEditingController hargaJualCtrl;

  @override
  void initState() {
    super.initState();
    barangIdCtrl =
        TextEditingController(text: widget.item?.barangId.toString() ?? '');
    tanggalCtrl = TextEditingController(text: widget.item?.tanggal ?? '');
    hargaBeliCtrl =
        TextEditingController(text: widget.item?.hargaBeli.toString() ?? '');
    hargaJualCtrl =
        TextEditingController(text: widget.item?.hargaJual.toString() ?? '');
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
              TextFormField(
                controller: barangIdCtrl,
                decoration: const InputDecoration(labelText: 'Barang ID'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? 'Barang ID tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: tanggalCtrl,
                decoration:
                    const InputDecoration(labelText: 'Tanggal (YYYY-MM-DD)'),
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
                barangId: int.parse(barangIdCtrl.text),
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
