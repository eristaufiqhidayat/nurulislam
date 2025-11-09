import 'package:flutter/material.dart';
import '../../../models/barang_harga_model.dart';

class HargaTableWidget extends StatelessWidget {
  final List<BarangHarga> items;
  final Function(BarangHarga) onEdit;
  final Function(int) onDelete;

  const HargaTableWidget({
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor:
          WidgetStatePropertyAll(Colors.green.shade700.withOpacity(0.2)),
      columns: const [
        DataColumn(label: Text("ID")),
        DataColumn(label: Text("Barang ID")),
        DataColumn(label: Text("Tanggal")),
        DataColumn(label: Text("Harga Beli")),
        DataColumn(label: Text("Harga Jual")),
        DataColumn(label: Text("Aksi")),
      ],
      rows: items.map((e) {
        return DataRow(cells: [
          DataCell(Text(e.id.toString())),
          DataCell(Text(e.barangId.toString())),
          DataCell(Text(e.tanggal)),
          DataCell(Text(e.hargaBeli.toString())),
          DataCell(Text(e.hargaJual.toString())),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(e),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(e.id!),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}
