// ignore_for_file: non_constant_identifier_names, control_flow_in_finally, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nurulislam/features/almawa/models/barang_masuk_inv_model.dart';
import 'package:nurulislam/features/almawa/models/barang_masuk_model.dart';
import 'package:nurulislam/features/almawa/pages/barang_masuk/detail_barang_masuk_table.dart';
import 'package:nurulislam/features/almawa/pages/barang_masuk/detail_form_barang_masuk_dialog.dart';
import 'package:nurulislam/features/almawa/services/barang_masuk_inv_service.dart';
import 'package:nurulislam/features/almawa/services/barang_masuk_service.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class DetailBarangMasukPage extends StatefulWidget {
  final int BarangMasukInvId;

  const DetailBarangMasukPage({super.key, required this.BarangMasukInvId});

  @override
  State<DetailBarangMasukPage> createState() => _DetailBarangMasukPageState();
}

class _DetailBarangMasukPageState extends State<DetailBarangMasukPage> {
  bool loading = false;
  final service = BarangMasukInvService();

  BarangMasukInvModel? item;
  List<BarangMasukModel>? items = [];

  @override
  void initState() {
    super.initState();
    loadData(); // 🔥 WAJIB! agar data terbaca
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => loading = true);

    try {
      final r1 = await service.fetchBy(widget.BarangMasukInvId);
      final r2 = await service.lfetchBy(widget.BarangMasukInvId);

      if (!mounted) return;
      item = r1;
      items = r2;
    } catch (e) {
      if (e.toString().contains('401')) {
        AuthHelper.handle401(context);
        return;
      }
      debugPrint("Error load data: $e");
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  void showForm(BarangMasukModel? d) {
    // ignore: unused_local_variable
    final parentContext = context; // simpan parent context

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final green = Colors.green.shade700;

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
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                /// FORM
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DetailFormBarangMasukDialog(
                      initial: d,
                      onSubmit: (map) async {
                        final model = BarangMasukModel(
                          id: d?.id,
                          idinv: widget.BarangMasukInvId,
                          barangId: map['barang_id'] ?? 0,
                          jumlah: map['jumlah'] ?? 0,
                          hargaBeli: (map['harga_beli'] ?? 0).toDouble(),
                          supplier: map['supplier'] ?? "",
                          tglMasuk: map['tanggal_masuk'] == null
                              ? DateTime.now()
                              : DateTime.parse(map['tanggal_masuk']),
                        );

                        // ignore: unnecessary_null_comparison
                        if (d == null) {
                          await BarangMasukService.create(model.toJson());
                        } else {
                          await BarangMasukService.update(
                              d.id!, model.toJson());
                        }

                        Navigator.pop(context); // tutup dialog

                        await Future.delayed(const Duration(milliseconds: 20));

                        if (!mounted) return;

                        await loadData(); // refresh halaman
                      }),
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
    // ignore: unused_local_variable
    final green = Colors.green.shade700;
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Detail Barang Masuk #${widget.BarangMasukInvId}',
        //🔥 BACK BUTTON
        leading: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),

      // 🔥 BODY
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : item == null
              ? const Center(child: Text("Data tidak ditemukan"))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Card(
                          elevation: 4,
                          color: Colors.green.shade800, // 💚 HIJAU TUA
                          shadowColor: Colors.green.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Id Invoice: ${item!.id}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // 🔥 PUTIH
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Tanggal: ${item!.tanggal}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // 🔥 PUTIH
                                  ),
                                ),
                                if (item!.supplier != null) ...[
                                  const Divider(
                                    color:
                                        Colors.white54, // ❗ Divider lebih soft
                                    thickness: 0.7,
                                  ),
                                  Text(
                                    "Supplier: ${item!.supplier!.nama}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white, // 🔥 PUTIH
                                    ),
                                  ),
                                  Text(
                                    "Alamat: ${item!.supplier!.alamat}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white, // 🔥 PUTIH
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Tombol New Barang
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            showForm(null); // buka dialog tambah baru
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800, // hijau tua
                            foregroundColor: Colors.white, // teks putih
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_box_sharp),
                              SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Tambah Barang",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      DetailBarangMasukTable(
                        items: items ?? [],
                        onEdit: showForm,
                        onDelete: (d) async {
                          await BarangMasukService.delete(d.id!);
                          await loadData();
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
