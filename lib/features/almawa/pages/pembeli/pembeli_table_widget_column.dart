import 'package:flutter/material.dart';
import '../../../../models/pembeli_model.dart';

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
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              WidgetStateProperty.all(Colors.green.withOpacity(0.2)),
          columns: const [
            DataColumn(label: Text('No')),
            DataColumn(label: Text('Nama')),
            DataColumn(label: Text('Alamat')),
            DataColumn(label: Text('No Telepon')),
            DataColumn(label: Text('Tanggal')),
            DataColumn(label: Text('Aksi')),
          ],
          rows: items.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final e = entry.value;
            return DataRow(cells: [
              DataCell(Text(index.toString())),
              DataCell(Text(e.nama)),
              DataCell(Text(e.alamat)),
              DataCell(Text(e.noTelepon)),
              DataCell(Text(e.createdAt.toString().split(' ')[0])),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => onEdit(e),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(e.id),
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
