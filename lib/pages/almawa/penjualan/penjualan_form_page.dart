import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

import '../../../config/api_constants.dart';
import '../../../models/penjualan_model.dart';
import '../../../models/pembeli_model.dart';
import '../../../services/penjualan_service.dart';
import '../../../utils/shared_prefs.dart';
import 'detail_penjualan_page.dart';

class PenjualanFormPage extends StatefulWidget {
  const PenjualanFormPage({super.key});

  @override
  State<PenjualanFormPage> createState() => _PenjualanFormPageState();
}

class _PenjualanFormPageState extends State<PenjualanFormPage> {
  final _formKey = GlobalKey<FormState>();
  PembeliModel? _selectedPembeli;
  DateTime _tglTransaksi = DateTime.now();
  bool _loading = false;

  // ✅ Ambil data pembeli dari API
  Future<List<PembeliModel>> _fetchPembeli(
      String filter, LoadProps? props) async {
    final token = await SharedPrefs.getToken();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/pembeli'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      List<dynamic> dataList = [];
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        dataList = decoded['data'];
      } else if (decoded is List) {
        dataList = decoded;
      }

      final list = dataList
          .map((e) => PembeliModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      if (filter.isEmpty) return list;
      return list
          .where((p) =>
              p.nama.toLowerCase().contains(filter.toLowerCase()) ||
              (p.noTelepon).toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      debugPrint('Gagal memuat pembeli: ${res.statusCode}');
      return [];
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_selectedPembeli == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih pembeli terlebih dahulu')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final model = PenjualanModel(
        pembeliId: _selectedPembeli!.id,
        tglTransaksi: _tglTransaksi,
      );

      final service = PenjualanService();
      final saved = await service.create(model);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPenjualanPage(penjualanId: saved.id!.toInt()),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final green = Colors.green.shade700;
    final borderRadius = BorderRadius.circular(12);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Form Penjualan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: green,
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: green.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Isi Data Penjualan',
                    style: TextStyle(
                      fontSize: 18,
                      color: green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Dropdown Pembeli (searchable)
                DropdownSearch<PembeliModel>(
                  items: (String filter, LoadProps? props) =>
                      _fetchPembeli(filter, props),
                  selectedItem: _selectedPembeli,
                  onChanged: (val) => setState(() => _selectedPembeli = val),
                  itemAsString: (p) => "${p.nama} (${p.noTelepon})",
                  compareFn: (a, b) => a.id == b.id, // ✅ FIX UTAMA
                  validator: (v) =>
                      v == null ? 'Pilih pembeli terlebih dahulu' : null,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Pilih Pembeli',
                      prefixIcon:
                          Icon(Icons.person, color: Colors.green.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Cari nama pembeli...',
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Pilih tanggal transaksi
                Text(
                  'Tanggal Transaksi',
                  style: TextStyle(fontWeight: FontWeight.w600, color: green),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: borderRadius,
                          border: Border.all(color: green.withOpacity(0.4)),
                        ),
                        child: Text(
                          _tglTransaksi.toLocal().toString().split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _tglTransaksi,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: green,
                                  onPrimary: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() => _tglTransaksi = picked);
                        }
                      },
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text('Pilih'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: borderRadius,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // Tombol submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.arrow_forward),
                    label: Text(
                      _loading ? 'Menyimpan...' : 'Lanjut ke Detail Penjualan',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
