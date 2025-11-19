import 'package:flutter/material.dart';
import '../../../models/supplier_model.dart';

class TableWidget extends StatelessWidget {
  final List<SupplierModel> items;
  final Function(SupplierModel) onEdit;
  final Function(int) onDelete;

  const TableWidget({
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
                            "Nama: ${item.nama}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Alamat: ${item.alamat}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            "Telp: Rp${item.telp}",
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
                          onTap: () => Future(() => onDelete(item.id)),
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
