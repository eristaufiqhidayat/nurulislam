import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ Tambahkan ini
import 'package:nurulislam/api/auth_service.dart';
import 'package:nurulislam/app.dart';
import 'package:nurulislam/pages/almawa/barang/barang_crud_page.dart';
import 'package:nurulislam/pages/dkm.dart';
import 'package:nurulislam/pages/kegiatan.dart';
import 'package:nurulislam/pages/menuRolepage.dart';
import 'package:nurulislam/pages/pagecontent_crud/page_contetnt_crud.dart';
import 'package:nurulislam/screens/admin_screen.dart';
import 'package:nurulislam/screens/home_screen.dart';
import 'package:nurulislam/screens/login_screen.dart';
import 'package:nurulislam/screens/splashscreen.dart';
import 'package:nurulislam/pages/donasi.dart';
import 'package:nurulislam/pages/contact.dart';

/// ✅ Fix utama ada di sini:
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi data lokal untuk tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(MyApp2());
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Aplikasi Masjid',
      initialRoute: '/',
      routes: {
        '/': (context) => const ResponsiveLayout(),
        '/dkm': (context) => const dkm(),
        '/donasi': (context) => const donasi(),
        '/contact': (context) => const contact(),
        '/kegiatan': (context) => const kegiatan(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminScreen(),
        '/pagecontent_crud': (context) => const pagecontent_crud(),
        '/menuRole': (context) => const MenuRolePage(),
        '/homepage': (context) => const HomeScreen(),
        '/pageInfo': (context) => const pagecontent_crud(),
        '/stokBarang': (context) => const pagecontent_crud(),
        '/barang': (context) => const BarangPage(),
      },
    );
  }
}

/// GoRouter untuk navigasi terkontrol
final _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final loggedIn = await AuthService.isLoggedIn();
    final loggingIn = state.fullPath == '/login';

    if (!loggedIn && !loggingIn) return '/login';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => AdminScreen(),
    ),
    GoRoute(
      path: '/pagecontent_crud',
      builder: (context, state) => pagecontent_crud(),
    ),
    GoRoute(
      path: '/dkm',
      builder: (context, state) => dkm(),
    ),
    GoRoute(
      path: '/kegiatan',
      builder: (context, state) => kegiatan(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Login API App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
