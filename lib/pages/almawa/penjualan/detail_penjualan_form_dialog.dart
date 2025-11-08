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

  InputDecoration _inputStyle(
      {required String label, required IconData icon, required Color green}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: green, fontWeight: FontWeight.w600),
      prefixIcon: Icon(icon, color: green),
      filled: true,
      fillColor: Colors.green.shade50.withOpacity(0.5),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: green, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: green.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final green = Colors.green.shade700;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🟩 Dropdown Barang
          DropdownButtonFormField<int>(
            value: _barangId,
            items: widget.barangOptions.map((b) {
              return DropdownMenuItem<int>(
                value: b.id,
                child: Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text(b.namaBarang),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) => setState(() => _barangId = v),
            validator: (v) => v == null ? 'Pilih barang terlebih dahulu' : null,
            decoration: _inputStyle(
                label: 'Pilih Barang', icon: Icons.inventory, green: green),
          ),
          const SizedBox(height: 16),

          // 🟩 Jumlah
          TextFormField(
            initialValue: _jumlah.toString(),
            decoration: _inputStyle(
              label: 'Jumlah Barang',
              icon: Icons.numbers,
              green: green,
            ),
            keyboardType: TextInputType.number,
            onSaved: (v) => _jumlah = int.tryParse(v ?? '1') ?? 1,
            validator: (v) =>
                (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Jumlah tidak valid' : null,
          ),
          const SizedBox(height: 16),

          // 🟩 Harga Jual
          TextFormField(
            initialValue: _hargaJual.toString(),
            decoration: _inputStyle(
              label: 'Harga Jual',
              icon: Icons.sell_outlined,
              green: green,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSaved: (v) => _hargaJual = double.tryParse(v ?? '0') ?? 0,
          ),
          const SizedBox(height: 16),

          // 🟩 Harga Beli
          TextFormField(
            initialValue: _hargaBeli.toString(),
            decoration: _inputStyle(
              label: 'Harga Beli',
              icon: Icons.attach_money_outlined,
              green: green,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSaved: (v) => _hargaBeli = double.tryParse(v ?? '0') ?? 0,
          ),
          const SizedBox(height: 24),

          // 🟩 Tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol batal (outline)
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: green),
                label: Text(
                  'Batal',
                  style: TextStyle(color: green, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: green, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),

              // Tombol simpan (filled)
              ElevatedButton.icon(
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
                  }
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
