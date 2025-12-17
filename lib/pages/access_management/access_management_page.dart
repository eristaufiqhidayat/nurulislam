import 'package:flutter/material.dart';
import 'package:nurulislam/pages/menus/menu_page.dart';
import 'package:nurulislam/pages/roles/roles_pages.dart';
import 'package:nurulislam/pages/user_crud/user_page.dart';
//import 'group_user/group_user_page.dart';
//import 'menu/menu_page.dart';
//import 'role/role_page.dart';

class AccessManagementPage extends StatelessWidget {
  const AccessManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade700,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Manajemen Akses',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'User'),
              Tab(icon: Icon(Icons.menu), text: 'Menus'),
              Tab(icon: Icon(Icons.security), text: 'Role'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserPage(), // ✅ tab// ✅ tab 2
            MenuPage(), // ✅ tab 3
            RolePage(), // ✅ tab 4
          ],
        ),
      ),
    );
  }
}
