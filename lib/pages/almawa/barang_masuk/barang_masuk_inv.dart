import 'package:flutter/material.dart';
import 'package:nurulislam/pages/almawa/barang_masuk/barang_masuk_form_inv.dart';
import 'package:nurulislam/pages/almawa/barang_masuk/detail_barang_masuk_page.dart';
import 'package:nurulislam/services/barang_masuk_inv_service.dart';
import 'package:nurulislam/models/barang_masuk_inv_model.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class BarangMasukInv extends StatefulWidget {
  const BarangMasukInv({super.key});

  @override
  State<BarangMasukInv> createState() => _BarangMasukInvState();
}

class _BarangMasukInvState extends State<BarangMasukInv> {
  late Future<List<BarangMasukInvModel>> _futurebarangmasukinv;
  late BarangMasukInvService service;

  @override
  void initState() {
    super.initState();

    /// Inisialisasi service
    service = BarangMasukInvService();

    /// Future untuk FutureBuilder
    _futurebarangmasukinv = service.fetch();
  }

  void _tambahbaranginv() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BarangMasukInvForm(),
      ),
    );
  }

  void _editbarangmasukinv(BarangMasukInvModel barang) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DetailBarangMasukPage(BarangMasukInvId: barang.id!),
      ),
    );
  }

  void _hapusPenjualan(BarangMasukInvModel barang) async {
    // ignore: unused_local_variable
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text("Yakin ingin menghapus data #${barang.id}?"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: "Barang Masuk Inventory",
      ),
      body: Column(
        children: [
          // Tombol New
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _tambahbaranginv,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "New Barang Masuk",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
            child: FutureBuilder<List<BarangMasukInvModel>>(
              future: _futurebarangmasukinv,
              builder: (context, snapshot) {
                //print(snapshot.error);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  if (snapshot.toString().contains('401')) {
                    AuthHelper.handle401(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Gagal test memuat data: $snapshot.error')));
                  }
                }

                final data = snapshot.data ?? [];

                if (data.isEmpty) {
                  return const Center(
                      child: Text("Belum ada data barang masuk."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final barang = data[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ExpansionTile(
                        leading:
                            const Icon(Icons.inventory, color: Colors.green),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID Inv: ${barang.id}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Nama: ${barang.supplier?.nama ?? 'Unknown'}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Alamat : ${barang.supplier?.alamat ?? 'Unknown'}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Text("Tanggal: ${barang.tanggal}"),
                        // ignore: sort_child_properties_last
                        children: barang.barangMasuk?.map((detail) {
                              return ListTile(
                                leading: const Icon(Icons.shopping_bag_outlined,
                                    color: Colors.green),
                                title: Text(detail.barang!.namaBarang),
                                subtitle: Text(
                                  "${detail.jumlah} pcs × ${(detail.hargaBeli)}",
                                ),
                              );
                            }).toList() ??
                            [],
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueAccent),
                              onPressed: () => _editbarangmasukinv(barang),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () => _hapusPenjualan(barang),
                            ),
                          ],
                        ),
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
