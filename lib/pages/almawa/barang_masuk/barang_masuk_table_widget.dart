import 'package:flutter/material.dart';
import '../../../models/barang_masuk_model.dart';

class BarangMasukTableWidget extends StatelessWidget {
  final List<BarangMasukModel>
      data; // ✅ ubah ke 'data' agar sama seperti BarangTableWidget
  final Function(BarangMasukModel) onEdit;
  final Function(int) onDelete;

  const BarangMasukTableWidget({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("Belum ada data pembelian barang"));
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.green.shade100,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Detail Barang Masuk
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
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jumlah: ${item.jumlah}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      "Harga Beli: Rp${item.hargaBeli.toStringAsFixed(0)}",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      "Supplier: ${item.supplier.isNotEmpty ? item.supplier : '-'}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      "Tanggal Masuk: ${item.tglMasuk.toString().split(' ')[0]}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Tombol Aksi
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
