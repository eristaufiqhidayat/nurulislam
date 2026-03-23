// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nurulislam/Home.dart';
import 'package:nurulislam/app.dart';
import 'package:nurulislam/pages/access_management/access_management_page.dart';
import 'package:nurulislam/pages/almawa/barang/barang_crud_page.dart';
import 'package:nurulislam/pages/almawa/barang_masuk/barang_masuk_inv.dart';
import 'package:nurulislam/pages/almawa/harga/harga_page.dart';
import 'package:nurulislam/pages/almawa/pembeli/pembeli_crud_page.dart';
import 'package:nurulislam/pages/almawa/penjualan/penjualan_page.dart';
import 'package:nurulislam/pages/almawa/supplier/supplier_page.dart';
import 'package:nurulislam/pages/dkm.dart';
import 'package:nurulislam/pages/forgot_password_page.dart';
import 'package:nurulislam/pages/kegiatan.dart';
import 'package:nurulislam/pages/page_info/page_info_crud.dart';
import 'package:nurulislam/pages/pagecontent_crud/page_contetnt_crud.dart';
import 'package:nurulislam/pages/password/change_password_page.dart';
import 'package:nurulislam/pages/cart/cart_page.dart';
import 'package:nurulislam/pages/product/product_list_page_admin.dart';
import 'package:nurulislam/pages/product/product_list_page_anggota.dart';
import 'package:nurulislam/pages/register/register_dialog.dart';
import 'package:nurulislam/pages/rekap_page.dart';
import 'package:nurulislam/pages/shop/shop_form_page.dart';
//import 'package:nurulislam/pages/shop/shop_page.dart';
import 'package:nurulislam/pages/tabunganqurban/tabungan_qurban_page.dart';
import 'package:nurulislam/providers/auth_provider.dart';
import 'package:nurulislam/screens/admin_screen.dart';
import 'package:nurulislam/screens/home_screen.dart';
import 'package:nurulislam/screens/login_screen.dart';
import 'package:nurulislam/pages/donasi.dart';
import 'package:nurulislam/pages/contact.dart';
import 'package:nurulislam/screens/splash_screen.dart';
import 'package:nurulislam/screens/version_software.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

/// ✅ Fix utama ada di sini:
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi data lokal untuk tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadUser()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
        '/': (context) => const SplashScreen(),
        '/home': (context) => const ResponsiveLayout(),
        '/homepage': (context) => const HomePage(),
        '/dashboard': (context) => const DashBoard(), //DashBoard
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/register': (context) => const RegisterDialog(),
        '/dkm': (context) => const dkm(),
        '/donasi': (context) => const donasi(),
        '/contact': (context) => ContactPage(),
        '/kegiatan': (context) => const kegiatan(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminScreen(),
        '/pagecontent_crud': (context) => const pagecontent_crud(),
        '/pageInfo': (context) => const PageInfoPage(),
        '/stokBarang': (context) => const pagecontent_crud(),
        '/barang': (context) => const BarangPage(),
        '/version_software': (context) => const version_software(),
        '/penjualan': (context) => const PenjualanPage(),
        '/barangMasuk': (context) => const BarangMasukInv(),
        '/pembeli': (context) => const PembeliPage(),
        '/rekapPenjualan': (context) => const RekapPenjualanPage(),
        '/suppliers': (context) => const SupplierPage(),
        '/hargaBarang': (context) => const HargaPage(),
        '/userCrud': (context) => const AccessManagementPage(),
        '/changePassword': (context) => const ChangePasswordPage(),
        '/tabunganQurban': (context) => const TabunganQurbanPage(),
        '/product': (context) => const ProductListPage(),
        '/productAnggota': (context) => const ProductListPageAngggota(),
        '/shop': (context) => const ShopFormPage(),
        '/cart': (context) => const CartPage(),
      },
    );
  }
}
