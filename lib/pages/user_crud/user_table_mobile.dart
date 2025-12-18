import 'package:flutter/material.dart';
import '../../models/user_crud_model.dart';

class UserTableMobile extends StatefulWidget {
  final List<UserModel> items;
  final void Function(UserModel) onEdit;
  final void Function(UserModel) onDelete;
  final int rowsPerPage;

  const UserTableMobile({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
    this.rowsPerPage = 10,
  });

  @override
  State<UserTableMobile> createState() => _UserTableMobileState();
}

class _UserTableMobileState extends State<UserTableMobile> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final totalRows = widget.items.length;
    final totalPages = (totalRows / widget.rowsPerPage).ceil();

    final startIndex = (currentPage - 1) * widget.rowsPerPage;
    final endIndex = (startIndex + widget.rowsPerPage < totalRows)
        ? startIndex + widget.rowsPerPage
        : totalRows;

    final pageItems = widget.items.sublist(startIndex, endIndex);

    return Column(
      children: [
        // 🔹 LIST CARD
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pageItems.length,
          itemBuilder: (context, index) {
            final user = pageItems[index];
            final number = startIndex + index + 1;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#$number',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => widget.onEdit(user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => widget.onDelete(user),
                            ),
                          ],
                        )
                      ],
                    ),

                    const Divider(),

                    _rowInfo('Nama', user.name),
                    _rowInfo('Email', user.email),
                    _rowInfo('Role', user.roleName ?? '-'),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        // 🔹 PAGINATION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hal $currentPage / $totalPages',
                style: const TextStyle(fontSize: 12),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _rowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
