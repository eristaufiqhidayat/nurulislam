import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurulislam/pages/almawa/penjualan/detail_penjualan_page.dart';
import 'package:nurulislam/pages/almawa/penjualan/penjualan_form_page.dart';
import '../../../models/penjualan_detil_model.dart';
import '../../../services/penjualan_service.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  late Future<List<Penjualan>> _futurePenjualan;

  @override
  void initState() {
    super.initState();
    _loadPenjualan();
  }

  void _loadPenjualan() {
    setState(() {
      _futurePenjualan = PenjualanService().fetchPenjualan();
    });
  }

  String formatRupiah(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  void _tambahPenjualan() {
    // TODO: Tambahkan navigasi atau dialog tambah penjualan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PenjualanFormPage(),
      ),
    );
  }

  void _editPenjualan(Penjualan penjualan) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPenjualanPage(penjualanId: penjualan.id),
      ),
    );
    // TODO: Arahkan ke halaman edit
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Edit penjualan #${penjualan.id}")),
    // );
  }

  void _hapusPenjualan(Penjualan penjualan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text("Yakin ingin menghapus penjualan #${penjualan.id}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      //await PenjualanService().deletePenjualan(penjualan.id);
      _loadPenjualan();
      PenjualanService().deletePenjualan(penjualan.id).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Penjualan berhasil dihapus.")),
        );
        _loadPenjualan();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus penjualan: $error")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Penjualan"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPenjualan,
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Tombol New di atas
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _tambahPenjualan,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "New Penjualan",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                ),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Penjualan>>(
              future: _futurePenjualan,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(child: Text("Belum ada data penjualan."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final penjualan = data[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ExpansionTile(
                        leading:
                            const Icon(Icons.receipt_long, color: Colors.green),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Nama Pembeli : ${penjualan.pembeli.nama}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: "Edit",
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueAccent),
                                  onPressed: () => _editPenjualan(penjualan),
                                ),
                                IconButton(
                                  tooltip: "Delete",
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () => _hapusPenjualan(penjualan),
                                ),
                              ],
                            )
                          ],
                        ),
                        subtitle: Text(
                          "${penjualan.tglTransaksi}\nTotal: ${formatRupiah(penjualan.totalHarga)}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        children: penjualan.details.map((detail) {
                          return ListTile(
                            leading: const Icon(Icons.shopping_bag_outlined,
                                color: Colors.green),
                            title: Text(detail.barang.namaBarang),
                            subtitle: Text(
                              "${detail.jumlah} pcs × ${formatRupiah(detail.hargaJual)}",
                            ),
                            trailing: Text(
                              formatRupiah(detail.jumlah * detail.hargaJual),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
