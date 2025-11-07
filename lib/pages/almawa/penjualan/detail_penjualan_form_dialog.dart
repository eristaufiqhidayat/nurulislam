import 'package:flutter/material.dart';
import '../../../models/barang_model.dart';
import '../../../models/detail_penjualan_model.dart';

class DetailPenjualanFormDialog extends StatefulWidget {
  final DetailPenjualan? initial;
  final List<BarangModel> barangOptions;
  final void Function(DetailPenjualan) onSubmit;

  const DetailPenjualanFormDialog({
    super.key,
    this.initial,
    required this.barangOptions,
    required this.onSubmit,
  });

  @override
  State<DetailPenjualanFormDialog> createState() =>
      _DetailPenjualanFormDialogState();
}

class _DetailPenjualanFormDialogState extends State<DetailPenjualanFormDialog> {
  final _formKey = GlobalKey<FormState>();

  int? _barangId;
  int _jumlah = 1;
  double _hargaJual = 0;
  double _hargaBeli = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _barangId = widget.initial!.barangId;
      _jumlah = widget.initial!.jumlah;
      _hargaJual = widget.initial!.hargaJual;
      _hargaBeli = widget.initial!.hargaBeli;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Tambah Detail' : 'Edit Detail'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _barangId,
                items: widget.barangOptions
                    .map(
                      (b) => DropdownMenuItem(
                        value: b.id,
                        child: Text(b.namaBarang),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _barangId = v),
                validator: (v) => v == null ? 'Pilih barang' : null,
                decoration: const InputDecoration(labelText: 'Barang'),
              ),
              TextFormField(
                initialValue: _jumlah.toString(),
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                onSaved: (v) => _jumlah = int.tryParse(v ?? '1') ?? 1,
                validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0
                    ? 'Jumlah tidak valid'
                    : null,
              ),
              TextFormField(
                initialValue: _hargaJual.toString(),
                decoration: const InputDecoration(labelText: 'Harga Jual'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (v) => _hargaJual = double.tryParse(v ?? '0') ?? 0,
              ),
              TextFormField(
                initialValue: _hargaBeli.toString(),
                decoration: const InputDecoration(labelText: 'Harga Beli'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (v) => _hargaBeli = double.tryParse(v ?? '0') ?? 0,
              ),
            ],
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
              _formKey.currentState!.save();
              final margin = (_hargaJual - _hargaBeli) * _jumlah;
              final detail = DetailPenjualan(
                id: widget.initial?.id,
                penjualanId: widget.initial?.penjualanId ?? 0,
                barangId: _barangId!,
                jumlah: _jumlah,
                hargaJual: _hargaJual,
                hargaBeli: _hargaBeli,
                margin: margin,
              );
              widget.onSubmit(detail);
              Navigator.pop(context);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
