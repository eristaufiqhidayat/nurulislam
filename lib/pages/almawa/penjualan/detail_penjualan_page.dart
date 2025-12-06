import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/models/penjualan_model.dart';
import 'package:nurulislam/pages/almawa/penjualan/penjualan_page.dart';
import 'package:nurulislam/services/penjualan_service.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
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
  late Future<PenjualanModel> _futurePenjualan;
  @override
  void initState() {
    super.initState();
    _loadPenjualan();
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

  void _loadPenjualan() {
    setState(() {
      _futurePenjualan =
          PenjualanService().fetchPenjualanBy(widget.penjualanId);
    });
  }

  Future<void> loadBarangs() async {
    final headers = await _headers();
    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/barang'),
      headers: headers,
    );
    //print("Detail Barang" + res.body);

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
      appBar: AppBarCustom(
        title: "Detail Penjualan",
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PenjualanPage()),
            );
          },
        ),
      ),

      body: Column(
        children: [
          FutureBuilder<PenjualanModel>(
            future: _futurePenjualan,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LinearProgressIndicator(color: Colors.green),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Error memuat data penjualan: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Data penjualan tidak ditemukan"),
                );
              }

              final penjualan = snapshot.data!; // ← DATA SUDAH SIAP

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: green,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Colors.green.withOpacity(0.6),
                    //     Colors.green.withOpacity(0.3),
                    //   ],
                    // ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==============================
                      //      HEADER: ID PENJUALAN
                      // ==============================
                      Text(
                        'Detail Penjualan #${penjualan.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ==============================
                      //       PEMBELI ID
                      // ==============================
                      Text(
                        'Pembeli ID : ${penjualan.pembeliId}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Nama Pembeli : ${penjualan.pembeli?.nama}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Alamat Pembeli : ${penjualan.pembeli?.alamat}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      // ==============================
                      //       TANGGAL TRANSAKSI
                      // ==============================
                      Text(
                        'Tanggal : ${penjualan.tglTransaksi}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),

                      // ==============================
                      //     TOTAL HARGA (OPSIONAL)
                      // ==============================
                      const SizedBox(height: 4),
                      Text(
                        'Total Harga : ',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green))
                : Padding(
                    padding: const EdgeInsets.all(12), // ⬅ lebih rapat dari 16
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(12), // sebelumnya 16
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.05),
                            blurRadius: 6, // ⬅ lebih soft
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: green.withOpacity(0.1)),
                      ),
                      padding:
                          const EdgeInsets.all(10), // ⬅ lebih rapat dari 16
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // lebih compact
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                                onPressed: () => showForm(),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text(
                                  'Tambah Barang',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(width: 8), // ⬅ lebih rapat dari 12
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: green,
                                  side: BorderSide(color: green, width: 1.6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                                onPressed: loadData,
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text(
                                  'Refresh',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8), // ⬅ lebih rapat dari 16

                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double
                                    .infinity, // ⬅️ memastikan mengikuti lebar maksimum
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: green.withOpacity(0.12)),
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
                          )
                        ],
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
