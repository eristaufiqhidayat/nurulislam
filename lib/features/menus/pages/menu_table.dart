import 'package:flutter/material.dart';
import '../../../models/menu_model.dart';

class MenuTable extends StatelessWidget {
  final List<MenuModel> items;
  final Function(MenuModel) onEdit;
  final Function(int) onDelete;

  const MenuTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Title')),
          DataColumn(label: Text('Route')),
          DataColumn(label: Text('Order')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: List.generate(items.length, (i) {
          final m = items[i];
          return DataRow(cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(m.title)),
            DataCell(Text(m.route ?? '-')),
            DataCell(Text(m.order.toString())),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit(m),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(m.id!),
                ),
              ],
            )),
          ]);
        }),
      ),
    );
  }
}
