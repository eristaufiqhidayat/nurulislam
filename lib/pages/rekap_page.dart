import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/api/api_constants.dart';
import 'package:nurulislam/utils/shared_prefs.dart';

class RekapPenjualanPage extends StatefulWidget {
  const RekapPenjualanPage({Key? key}) : super(key: key);

  @override
  State<RekapPenjualanPage> createState() => _RekapPenjualanPageState();
}

class _RekapPenjualanPageState extends State<RekapPenjualanPage> {
  Map<String, dynamic>? summary;
  bool isLoading = false;
  int? selectedMonth;
  int? selectedYear;

  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchRekap() async {
    final headers = await _headers();
    setState(() => isLoading = true);

    final queryParams = {
      if (selectedMonth != null) 'month': selectedMonth.toString(),
      if (selectedYear != null) 'year': selectedYear.toString(),
    };

    final uri = Uri.parse('${ApiConstants.baseUrl}/api/transaksi/rekap')
        .replace(queryParameters: queryParams);

    try {
      final res = await http.get(uri, headers: headers);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          summary = (data['data'] as List).isNotEmpty ? data['data'][0] : null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${res.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  String getMonthName(int month) {
    return DateFormat.MMMM('id_ID').format(DateTime(0, month));
  }

  @override
  void initState() {
    super.initState();
    fetchRekap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 4,
        automaticallyImplyLeading:
            false, // supaya kita bisa custom tombol panah
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 4),
            const Text(
              'Rekap Penjualan Bulanan',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20, // 🔹 proporsional, tidak terlalu besar
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFilterSection(),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : summary == null
                      ? const Center(child: Text('Tidak ada data'))
                      : ListView(
                          children: [
                            _buildSummaryCard(
                              icon: Icons.calendar_today,
                              title: "Periode",
                              value:
                                  "${summary!['bulan'] != null ? getMonthName(summary!['bulan']) : '-'} ${summary!['tahun'] ?? ''}",
                            ),
                            _buildSummaryCard(
                              icon: Icons.savings,
                              title: "Total Modal",
                              value: _toRupiah(summary!['total_modal']),
                            ),
                            _buildSummaryCard(
                              icon: Icons.shopping_bag,
                              title: "Total Barang Keluar",
                              value:
                                  "${summary!['total_barang_keluar'] ?? 0} pcs",
                            ),
                            _buildSummaryCard(
                              icon: Icons.attach_money,
                              title: "Total Penjualan",
                              value: _toRupiah(summary!['total_penjualan']),
                            ),
                            _buildSummaryCard(
                              icon: Icons.trending_up,
                              title: "Total Margin",
                              value: _toRupiah(summary!['total_margin']),
                            ),
                            _buildSummaryCard(
                              icon: Icons.inventory_2,
                              title: "Total Sisa Barang",
                              value:
                                  "${summary!['total_sisa_barang'] ?? 0} pcs",
                            ),
                            _buildSummaryCard(
                              icon: Icons.calculate,
                              title: "Nilai Barang Tersisa",
                              value: _toRupiah(summary!['total_harga_tersisa']),
                            ),
                            _buildSummaryCard(
                              icon: Icons.store,
                              title: "Total Stok Semua Barang",
                              value:
                                  "${summary!['total_stok_semua_barang'] ?? 0} pcs",
                            ),
                            const Divider(height: 24, thickness: 1),
                            _buildSummaryCard(
                              icon: Icons.account_balance_wallet,
                              title: "💹 Selisih Modal (Profit / Rugi)",
                              value: _toRupiah(_hitungSelisih()),
                            ),
                            const SizedBox(height: 20),
                            _buildStockTable(),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  /// 💵 Helper konversi format Rupiah
  String _toRupiah(dynamic value) {
    final val = double.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(val);
  }

  /// 🔢 Hitung profit/loss sementara
  double _hitungSelisih() {
    final totalPenjualan =
        double.tryParse(summary!['total_penjualan'].toString()) ?? 0;
    final totalAset =
        double.tryParse(summary!['total_harga_tersisa'].toString()) ?? 0;
    final totalModal = double.tryParse(summary!['total_modal'].toString()) ?? 0;
    return (totalPenjualan + totalAset) - totalModal;
  }

  /// 📋 Filter Bulan & Tahun
  Widget _buildFilterSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.green[100],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Bulan',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                value: selectedMonth,
                items: List.generate(12, (index) {
                  final month = index + 1;
                  return DropdownMenuItem(
                    value: month,
                    child: Text(getMonthName(month)),
                  );
                }),
                onChanged: (value) => setState(() => selectedMonth = value),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Tahun',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                value: selectedYear,
                items: List.generate(5, (index) {
                  final year = DateTime.now().year - index;
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year.toString()),
                  );
                }),
                onChanged: (value) => setState(() => selectedYear = value),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onPressed: fetchRekap,
              icon: const Icon(Icons.search),
              label: const Text('Filter'),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 Widget ringkasan (kartu)
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(icon, color: Colors.green[800]),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  /// 📦 Tabel stok per item barang
  Widget _buildStockTable() {
    final List items = summary!['stok_per_item'] ?? [];

    if (items.isEmpty) {
      return const Text(
        "Tidak ada data stok barang.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📋 Stok Per Item Barang",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.green[100]),
                columns: const [
                  DataColumn(label: Text('Nama Barang')),
                  DataColumn(label: Text('Stok')),
                  DataColumn(label: Text('Harga Beli')),
                  DataColumn(label: Text('Nilai Total')),
                ],
                rows: items.map<DataRow>((item) {
                  final stok = item['stok'] ?? 0;
                  final harga = item['harga_beli'] ?? 0;
                  final total = item['total_nilai'] ?? 0;

                  return DataRow(cells: [
                    DataCell(Text(item['nama_barang'].toString())),
                    DataCell(Text(stok.toString())),
                    DataCell(Text(_toRupiah(harga))),
                    DataCell(Text(_toRupiah(total))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
