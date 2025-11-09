import 'package:flutter/material.dart';
import '../../models/user_crud_model.dart';

class UserTable extends StatefulWidget {
  final List<UserModel> items;
  final void Function(UserModel) onEdit;
  final void Function(UserModel) onDelete;
  final int rowsPerPage; // jumlah baris per halaman

  const UserTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.rowsPerPage = 10,
  });

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final totalRows = widget.items.length;
    final totalPages =
        (totalRows / widget.rowsPerPage).ceil(); // hitung jumlah halaman

    // ambil data sesuai halaman aktif
    final startIndex = (currentPage - 1) * widget.rowsPerPage;
    final endIndex = (startIndex + widget.rowsPerPage < totalRows)
        ? startIndex + widget.rowsPerPage
        : totalRows;
    final pageItems = widget.items.sublist(startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Data Table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                WidgetStatePropertyAll(Colors.green.shade700.withOpacity(0.2)),
            columnSpacing: 10,
            border: TableBorder.all(color: Colors.grey.shade400, width: 1),
            dataRowMinHeight: 28,
            dataRowMaxHeight: 36,
            columns: const [
              DataColumn(label: Text('No', style: TextStyle(fontSize: 12))),
              DataColumn(label: Text('Nama', style: TextStyle(fontSize: 12))),
              DataColumn(label: Text('Email', style: TextStyle(fontSize: 12))),
              DataColumn(label: Text('Role', style: TextStyle(fontSize: 12))),
              DataColumn(label: Text('Aksi', style: TextStyle(fontSize: 12))),
            ],
            rows: List.generate(pageItems.length, (index) {
              final user = pageItems[index];
              final rowNumber = startIndex + index + 1;
              return DataRow(
                cells: [
                  DataCell(
                      Text('$rowNumber', style: const TextStyle(fontSize: 12))),
                  DataCell(
                      Text(user.name, style: const TextStyle(fontSize: 12))),
                  DataCell(
                      Text(user.email, style: const TextStyle(fontSize: 12))),
                  DataCell(Text(user.roleName ?? '-',
                      style: const TextStyle(fontSize: 12))),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => widget.onEdit(user),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => widget.onDelete(user),
                      ),
                    ],
                  )),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: 8),

        // 🔹 Pagination Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menampilkan ${startIndex + 1} - $endIndex dari $totalRows data',
              style: const TextStyle(fontSize: 12),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.first_page),
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage = 1)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                ),
                Text(
                  'Halaman $currentPage dari $totalPages',
                  style: const TextStyle(fontSize: 12),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage++)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.last_page),
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage = totalPages)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
