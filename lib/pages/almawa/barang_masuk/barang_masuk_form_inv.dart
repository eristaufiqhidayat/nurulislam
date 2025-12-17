// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/barang_masuk_inv_model.dart';
import 'package:nurulislam/models/supplier_model.dart';
import 'package:nurulislam/pages/almawa/barang_masuk/detail_barang_masuk_page.dart';
import 'package:nurulislam/services/barang_masuk_inv_service.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class BarangMasukInvForm extends StatefulWidget {
  const BarangMasukInvForm({super.key});

  @override
  State<BarangMasukInvForm> createState() => _BarangMasukInvFormState();
}

class _BarangMasukInvFormState extends State<BarangMasukInvForm> {
  DateTime _tglTransaksi = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  SupplierModel? _selectedSuuplier;
  bool _loading = false;

  Future<List<SupplierModel>> _fetchsupplier(
      String filter, LoadProps? props) async {
    final token = await SharedPrefs.getToken();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/supplier'),
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
          .map((e) => SupplierModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      if (filter.isEmpty) return list;
      return list
          .where((p) =>
              p.nama.toLowerCase().contains(filter.toLowerCase()) ||
              (p.telp).toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      if (res.toString().contains('401')) {
        AuthHelper.handle401(context);
        return [];
      } else {
        debugPrint('Gagal memuat pembeli: ${res.statusCode}');
        return [];
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // if (_selectedPembeli == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Pilih pembeli terlebih dahulu')),
    //   );
    //   return;
    // }

    setState(() => _loading = true);
    try {
      final model = BarangMasukInvModel(
        idSupplier: _selectedSuuplier!.id!,
        tanggal: _tglTransaksi,
      );

      final service = BarangMasukInvService();
      final saved = await service.create(model);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DetailBarangMasukPage(BarangMasukInvId: saved.id!.toInt()),
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
      appBar: AppBarCustom(
        title: "Form Barang Masuk",
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
                    'Isi Data Suplier dan Tanggal Barang Masuk',
                    style: TextStyle(
                      fontSize: 18,
                      color: green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Supplier',
                  style: TextStyle(fontWeight: FontWeight.w600, color: green),
                ),
                const SizedBox(height: 8),
                //✅ Dropdown Pembeli (searchable)
                DropdownSearch<SupplierModel>(
                  items: (String filter, LoadProps? props) =>
                      _fetchsupplier(filter, props),
                  selectedItem: _selectedSuuplier,
                  onChanged: (val) => setState(() => _selectedSuuplier = val),
                  itemAsString: (p) => "${p.nama} (${p.telp})",
                  compareFn: (a, b) => a.id == b.id, // ✅ FIX UTAMA
                  validator: (v) =>
                      v == null ? 'Pilih Supplier terlebih dahulu' : null,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: 'Pilih Supplier',
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
                        hintText: 'Cari nama Supplier...',
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
                      _loading ? 'Menyimpan...' : 'Lanjut ke Detail Barang',
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
