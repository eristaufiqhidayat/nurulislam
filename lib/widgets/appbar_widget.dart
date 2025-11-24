import 'package:flutter/material.dart';
import 'package:nurulislam/config/theme_config.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String routeName;
  final String title;
  final Widget? leading;

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
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      leading: leading ??
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
