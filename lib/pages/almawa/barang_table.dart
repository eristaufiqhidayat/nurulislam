import 'package:flutter/material.dart';

class BarangTable extends StatelessWidget {
  final List barangList;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;

  const BarangTable({
    super.key,
    required this.barangList,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return barangList.isEmpty
        ? const Center(child: Text('Belum ada data barang'))
        : ListView.builder(
            itemCount: barangList.length,
            itemBuilder: (context, index) {
              final item = barangList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    item['nama_barang'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Kategori: ${item['kategori'] ?? '-'}'),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.redAccent),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit(item);
                      } else if (value == 'delete') {
                        onDelete(item);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
