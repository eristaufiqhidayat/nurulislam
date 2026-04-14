import 'package:flutter/material.dart';
import 'package:nurulislam/features/tabunganqurban/pages/tabungan_qurban_list_detail.dart';
import '../../../models/tabungan_qurban_model.dart';

class TabunganQurbanListMobile extends StatelessWidget {
  final List<TabunganQurbanModel> data;

  const TabunganQurbanListMobile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        final e = data[i];
        final progress = e.totalSetoran / e.targetNominal;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF8F3), // hijau soft
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.green.shade300,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            title: Text(
              'Jamaah ${e.jamaah?.name ?? "-"}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF1B5E20),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Rp ${e.totalSetoran} / ${e.targetNominal}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  'Status: ${e.status}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress > 1 ? 1 : progress,
                    minHeight: 8,
                    backgroundColor: Colors.green.shade100,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.green.shade600,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// ✏️ EDIT
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // TODO: buka dialog / page edit
                    debugPrint('Edit tabungan id: ${e.id}');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                /// 🗑️ DELETE
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Hapus Data'),
                        content:
                            const Text('Yakin ingin menghapus tabungan ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // TODO: panggil service delete
                      debugPrint('Delete tabungan id: ${e.id}');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                /// ➕ DETAIL / SETORAN
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => TabunganQurbanListDetail(id: e.id),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.visibility, // 👁 VIEW
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
