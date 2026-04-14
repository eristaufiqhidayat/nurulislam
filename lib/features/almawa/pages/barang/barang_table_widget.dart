import 'package:flutter/material.dart';
import '../../../../models/barang_model.dart';

class BarangTableWidget extends StatelessWidget {
  final List<BarangModel> items;
  final Function(BarangModel) onEdit;
  final Function(int) onDelete;

  const BarangTableWidget({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.namaBarang,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Kategori: ${item.kategori}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            "Harga: Rp${item.hargaJual.toStringAsFixed(0)} | Stok: ${item.stok}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert, color: Colors.blueGrey),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 6),
                              Text("Edit")
                            ],
                          ),
                          onTap: () => Future(() => onEdit(item)),
                        ),
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 6),
                              Text("Hapus")
                            ],
                          ),
                          onTap: () => Future(() => onDelete(item.id!)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }
}
