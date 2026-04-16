import 'package:flutter/material.dart';
import 'package:nurulislam/features/tabunganqurban/pages/dialog_setoran.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';
import '../models/tabungan_qurban_detail_model.dart';
import '../services/tabungan_qurban_service.dart';

class TabunganQurbanListDetail extends StatefulWidget {
  final int? id;

  const TabunganQurbanListDetail({super.key, this.id});

  @override
  State<TabunganQurbanListDetail> createState() =>
      _TabunganQurbanListDetailState();
}

class _TabunganQurbanListDetailState extends State<TabunganQurbanListDetail> {
  final TabunganQurbanService _service = TabunganQurbanService();

  late Future<List<TabunganQurbanDetailModel>> _future;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _loadData();
    }
  }

  void _loadData() {
    _future = _service.fetchDetailDetail(widget.id!);
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus setoran ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteData(id);
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      await _service.deleteDetail(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Setoran berhasil dihapus')),
      );

      setState(() {
        _loadData();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id == null) {
      return const Center(child: Text('ID tabungan tidak tersedia'));
    }

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Detail Setoran Tabungan',
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // sudut kotak
        ),
        backgroundColor: const Color(0xFF2E7D32), // hijau tegas
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await showDialog<bool>(
            context: context,
            builder: (_) => DialogSetoran(tabunganId: widget.id!),
          );
          setState(() {
            _loadData();
          });
        },
      ),
      endDrawer: MobileDrawer(),
      body: FutureBuilder<List<TabunganQurbanDetailModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text('Belum ada setoran'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final e = data[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: const Color(0xFFE8F5E9), // hijau soft
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  title: Text(
                    'Setoran #${e.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Tanggal : ${e.tanggal}'),
                      Text(
                        'Rp ${e.nominal} • ${e.metode}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  /// 👉 ICON EDIT & DELETE
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EDIT
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          color: const Color(0xFF2E7D32),
                          tooltip: 'Edit',
                          onPressed: () {
                            // TODO: dialog edit setoran
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // DELETE
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: const Color(0xFFD32F2F),
                          tooltip: 'Hapus',
                          onPressed: () {
                            _confirmDelete(e.id);
                            // TODO: konfirmasi hapus
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
