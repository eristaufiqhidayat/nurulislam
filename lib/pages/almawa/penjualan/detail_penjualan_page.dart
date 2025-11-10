import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/utils/shared_prefs.dart';
import '../../../api/api_constants.dart';
import '../../../models/barang_model.dart';
import '../../../models/detail_penjualan_model.dart';
import '../../../services/detail_penjualan_service.dart';
import 'detail_penjualan_form_dialog.dart';
import 'detail_penjualan_table.dart';

class DetailPenjualanPage extends StatefulWidget {
  final int penjualanId;
  const DetailPenjualanPage({super.key, required this.penjualanId});

  @override
  State<DetailPenjualanPage> createState() => _DetailPenjualanPageState();
}

class _DetailPenjualanPageState extends State<DetailPenjualanPage> {
  final service = DetailPenjualanService();
  List<DetailPenjualan> items = [];
  List<BarangModel> barangs = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadBarangs();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      items = await service.fetchById(widget.penjualanId);
    } finally {
      setState(() => loading = false);
    }
  }

  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> loadBarangs() async {
    final headers = await _headers();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/barang'),
      headers: headers,
    );

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);

      final List<dynamic> dataList =
          (decoded is Map<String, dynamic> && decoded['data'] is List)
              ? decoded['data']
              : (decoded is List ? decoded : []);

      barangs = dataList.map((e) {
        try {
          return BarangModel.fromJson(Map<String, dynamic>.from(e));
        } catch (err) {
          return BarangModel(
            id: 0,
            namaBarang: 'Error',
            kategori: '',
            satuan: '',
            hargaBeli: 0,
            hargaJual: 0,
            stok: 0,
          );
        }
      }).toList();

      setState(() {});
    }
  }

  void showForm([DetailPenjualan? d]) {
    showDialog(
      context: context,
      barrierDismissible: false, // biar user gak bisa tutup tanpa tombol
      builder: (BuildContext context) {
        final green = Colors.green.shade700;
        //final lightGreen = Colors.green.shade50;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Header hijau
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        d == null
                            ? 'Tambah Detail Penjualan'
                            : 'Edit Detail Penjualan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // ✅ Isi form (putih)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DetailPenjualanFormDialog(
                    initial: d,
                    barangOptions: barangs,
                    onSubmit: (val) async {
                      val = DetailPenjualan(
                        id: val.id,
                        penjualanId: widget.penjualanId,
                        barangId: val.barangId,
                        jumlah: val.jumlah,
                        hargaJual: val.hargaJual,
                        hargaBeli: val.hargaBeli,
                        margin: val.margin,
                      );

                      if (d == null) {
                        await service.create(val);
                      } else {
                        await service.update(d.id!, val);
                      }

                      if (mounted) {
                        Navigator.pop(context);
                        await loadData();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final green = Colors.green.shade700;

    return Scaffold(
      backgroundColor: Colors.white, // ✅ Background putih bersih
      appBar: AppBar(
        title: Text(
          'Detail Penjualan #${widget.penjualanId}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: green,
        elevation: 3,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: green.withOpacity(0.1)),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            elevation: 2,
                          ),
                          onPressed: () => showForm(),
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Tambah Barang',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: green,
                            side: BorderSide(color: green, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: loadData,
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            'Refresh',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ✅ Tabel Detail Penjualan
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(color: green.withOpacity(0.15)),
                        ),
                        child: DetailPenjualanTable(
                          items: items,
                          onEdit: showForm,
                          onDelete: (d) async {
                            await service.delete(d.id!);
                            await loadData();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
