import 'package:flutter/material.dart';
import '../../../models/pembeli_model.dart';

class PembeliTableWidget extends StatelessWidget {
  final List<PembeliModel> items;
  final Function(PembeliModel) onEdit;
  final Function(int) onDelete;

  const PembeliTableWidget({
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
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nomor urut
                    Padding(
                      padding: const EdgeInsets.only(right: 8, top: 6),
                      child: Text(
                        "${index + 1}.",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),

                    // Informasi Pembeli
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Alamat: ${item.alamat}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            "No. Telepon: ${item.noTelepon}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Dibuat: ${item.createdAt.toString().split(' ')[0]}",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Tombol Popup Aksi
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert, color: Colors.blueGrey),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 6),
                              Text("Edit"),
                            ],
                          ),
                          onTap: () => Future(() => onEdit(item)),
                        ),
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 6),
                              Text("Hapus"),
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
