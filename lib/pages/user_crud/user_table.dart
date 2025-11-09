import 'package:flutter/material.dart';
import '../../models/user_crud_model.dart';

class UserTable extends StatelessWidget {
  final List<UserModel> items;
  final void Function(UserModel) onEdit;
  final void Function(UserModel) onDelete;

  const UserTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Colors.green.shade100),
      columns: const [
        DataColumn(label: Text('No')),
        DataColumn(label: Text('Nama')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Aksi')),
      ],
      rows: List.generate(items.length, (index) {
        final user = items[index];
        return DataRow(cells: [
          DataCell(Text('${index + 1}')),
          DataCell(Text(user.name)),
          DataCell(Text(user.email)),
          DataCell(Text(user.roleName ?? '-')),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(user),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(user),
              ),
            ],
          )),
        ]);
      }),
    );
  }
}
