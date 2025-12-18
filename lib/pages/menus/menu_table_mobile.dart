import 'package:flutter/material.dart';
import '../../models/menu_model.dart';

class MenuTableMobile extends StatelessWidget {
  final List<MenuModel> items;
  final Function(MenuModel) onEdit;
  final Function(int) onDelete;

  const MenuTableMobile({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final menu = items[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(
              menu.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (menu.route != null) Text('Route: ${menu.route}'),
                Text('Parent ID: ${menu.parentId ?? "-"}'),
                Text('Order: ${menu.order}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') onEdit(menu);
                if (value == 'delete') onDelete(menu.id!);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Hapus')),
              ],
            ),
          ),
        );
      },
    );
  }
}
