import 'package:flutter/material.dart';
import 'package:nurulislam/config/theme_config.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String routeName;
  final String title;
  final List<Widget>? leading;

  const AppBarCustom({
    super.key,
    this.routeName = "",
    this.title = "Phase 3",
    this.leading, // Default judul
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeConfig.basicColor,
      title: Align(
        alignment: Alignment.centerLeft, // Sesuaikan jika perlu
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, color: ThemeConfig.Font),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: leading,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
