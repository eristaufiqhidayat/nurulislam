import 'package:flutter/material.dart';
import 'package:nurulislam/services/detail_penjualan_service.dart';
import '../../../../models/barang_model.dart';
import '../../../../models/detail_penjualan_model.dart';

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
  bool _loadingHarga = false;

  // 🟩 Controller agar nilai bisa berubah dari API
  late final TextEditingController _hargaJualController;
  late final TextEditingController _hargaBeliController;
  late final TextEditingController _jumlahController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi dari initial (kalau ada)
    if (widget.initial != null) {
      _barangId = widget.initial!.barangId;
      _jumlah = widget.initial!.jumlah;
      _hargaJual = widget.initial!.hargaJual;
      _hargaBeli = widget.initial!.hargaBeli;
    }

    // Inisialisasi controller dengan nilai awal
    _hargaJualController =
        TextEditingController(text: _hargaJual.toStringAsFixed(0));
    _hargaBeliController =
        TextEditingController(text: _hargaBeli.toStringAsFixed(0));
    _jumlahController = TextEditingController(text: _jumlah.toString());

    // Jika barang_id sudah ada, ambil harga dari server
    if (_barangId != null) {
      _loadHarga(_barangId!);
    }
  }

  Future<void> _loadHarga(int barangId) async {
    setState(() => _loadingHarga = true);
    try {
      final hargaResponse = await DetailPenjualanService().getHarga(
        barangId: barangId,
        tanggal: DateTime.now().toIso8601String(),
      );

      if (hargaResponse.success) {
        setState(() {
          _hargaBeli = hargaResponse.hargaBeli;
          _hargaJual = hargaResponse.hargaJual;

          // Update controller agar UI berubah
          _hargaBeliController.text = _hargaBeli.toStringAsFixed(0);
          _hargaJualController.text = _hargaJual.toStringAsFixed(0);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ Tidak ada harga berlaku')),
        );
      }
    } catch (e) {
      print('❌ Gagal memuat harga: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat harga: $e')),
      );
    } finally {
      setState(() => _loadingHarga = false);
    }
  }

  @override
  void dispose() {
    _hargaJualController.dispose();
    _hargaBeliController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  InputDecoration _inputStyle({
    required String label,
    required IconData icon,
    required Color green,
  }) {
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
            initialValue: _barangId,
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
            onChanged: (v) {
              setState(() => _barangId = v);
              if (v != null) _loadHarga(v); // ✅ ambil harga otomatis
            },
            validator: (v) => v == null ? 'Pilih barang terlebih dahulu' : null,
            decoration: _inputStyle(
              label: 'Pilih Barang',
              icon: Icons.inventory,
              green: green,
            ),
          ),
          const SizedBox(height: 16),

          // 🟩 Jumlah
          TextFormField(
            controller: _jumlahController,
            decoration: _inputStyle(
              label: 'Jumlah Barang',
              icon: Icons.numbers,
              green: green,
            ),
            keyboardType: TextInputType.number,
            onChanged: (v) => _jumlah = int.tryParse(v.isEmpty ? '0' : v) ?? 1,
            validator: (v) =>
                (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Jumlah tidak valid' : null,
          ),
          const SizedBox(height: 16),

          // 🟩 Harga Jual
          TextFormField(
            controller: _hargaJualController,
            readOnly: true, // agar user tidak ubah manual
            decoration: _inputStyle(
              label: _loadingHarga ? 'Memuat harga jual...' : 'Harga Jual (Rp)',
              icon: Icons.sell_outlined,
              green: green,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),

          // 🟩 Harga Beli
          TextFormField(
            controller: _hargaBeliController,
            readOnly: true,
            decoration: _inputStyle(
              label: _loadingHarga ? 'Memuat harga beli...' : 'Harga Beli (Rp)',
              icon: Icons.attach_money_outlined,
              green: green,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),

          // 🟩 Tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
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
