import 'package:flutter/material.dart';
// import 'package:nurulislam/widgets/header.dart';
import '../models/user_model.dart';
import '../models/menu_model.dart';
import '../api/auth_service.dart';
import '../utils/shared_prefs.dart';
import '../utils/menu_utils.dart';
import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MenuItem>> _menuFuture;
  List<MenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();

    _menuFuture = AuthService.getUserMenu(widget.user.role);
    _menuFuture.then((menu) => setState(() => _menuItems = menu));
  }

  void _navigateToScreen(MenuItem item) {
    switch (item.route) {
      case '/admin':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdminScreen()),
        );
        break;
      // Add more cases for other routes
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Screen not implemented: ${item.route}')),
        );
    }
  }

  Future<void> _logout() async {
    await SharedPrefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          //const MosqueHeader(),

          SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: FutureBuilder<List<MenuItem>>(
                future: _menuFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error Home Screen: ${snapshot.error}'));
                  }

                  final accessibleMenu = MenuUtils.filterMenuByRole(
                    _menuItems,
                    widget.user.role,
                  );
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: accessibleMenu.map((item) {
                      return GestureDetector(
                        onTap: () => _navigateToScreen(item),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                //'assets/icons/${item.icon}.png',
                                'assets/images/masjid.jpg',
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text("${item.title}", textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    }).toList(),
                  );

                  //print(accessibleMenu);
                  // return ListView.builder(
                  //   itemCount: accessibleMenu.length,
                  //   itemBuilder: (context, index) {
                  //     final item = accessibleMenu[index];
                  //     return ListTile(
                  //       leading: Icon(_getIconData(item.icon)),
                  //       title: Text(item.title),
                  //       onTap: () => _navigateToScreen(item),
                  //     );
                  //   },
                  // );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // IconData _getIconData(String iconName) {
  //   switch (iconName) {
  //     case 'dashboard':
  //       return Icons.dashboard;
  //     case 'admin':
  //       return Icons.admin_panel_settings;
  //     case 'settings':
  //       return Icons.settings;
  //     default:
  //       return Icons.list;
  //   }
  // }
}
