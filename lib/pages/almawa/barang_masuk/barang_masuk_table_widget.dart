import 'package:flutter/material.dart';
import '../../../models/barang_masuk_model.dart';

class BarangMasukTableWidget extends StatelessWidget {
  final List<BarangMasukModel> data;
  final void Function(BarangMasukModel) onEdit;
  final void Function(int) onDelete;

  const BarangMasukTableWidget({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // ✅ Biar bisa scroll ke kanan
      child: DataTable(
        headingRowColor:
            WidgetStateColor.resolveWith((_) => Colors.green.shade50),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Nama Barang')),
          DataColumn(label: Text('Jumlah')),
          DataColumn(label: Text('Tanggal Masuk')),
          DataColumn(label: Text('Harga Beli')),
          DataColumn(label: Text('Supplier')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: data.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final item = entry.value;
          return DataRow(
            cells: [
              DataCell(Text(index.toString())),
              DataCell(Text(item.namaBarang)),
              DataCell(Text(item.jumlah.toString())),
              DataCell(Text(item.tglMasuk.toString().split(' ')[0])),
              DataCell(Text(item.hargaBeli.toStringAsFixed(0))),
              DataCell(Text(item.supplier.isEmpty ? '-' : item.supplier)),
              DataCell(Row(
                mainAxisSize: MainAxisSize.min, // ✅ biar gak melebihi cell
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () => onEdit(item),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(item.id),
                    tooltip: 'Hapus',
                  ),
                ],
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
