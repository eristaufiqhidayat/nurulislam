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
  const DetailPenjualanPage({super.key});

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
    loadData();
    loadBarangs();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      items = await service.fetchAll();
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

    print('Response code: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);

      // ✅ Ambil list barang dari key "data"
      final List<dynamic> dataList =
          (decoded is Map<String, dynamic> && decoded['data'] is List)
              ? decoded['data']
              : (decoded is List ? decoded : []);

      // ✅ Konversi ke model
      barangs = dataList.map((e) {
        try {
          return BarangModel.fromJson(Map<String, dynamic>.from(e));
        } catch (err) {
          print('❌ Gagal parse barang: $err');
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

      print('✅ Barang loaded: ${barangs.length}');
      for (var b in barangs) {
        print('📦 ${b.id} | ${b.namaBarang}');
      }

      setState(() {});
    } else {
      print('❌ Gagal memuat data barang: ${res.statusCode}');
    }
  }

  void showForm([DetailPenjualan? d]) {
    showDialog(
      context: context,
      builder: (_) => DetailPenjualanFormDialog(
        initial: d,
        barangOptions: barangs,
        onSubmit: (val) async {
          if (d == null) {
            await service.create(val);
          } else {
            await service.update(d.id!, val);
          }
          await loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Penjualan')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => showForm(),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: loadData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: DetailPenjualanTable(
                      items: items,
                      onEdit: showForm,
                      onDelete: (d) async {
                        await service.delete(d.id!);
                        await loadData();
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
