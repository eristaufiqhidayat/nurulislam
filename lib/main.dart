import 'package:flutter/material.dart';
import 'package:nurulislam/app.dart';
import 'package:nurulislam/pages/dkm.dart';
import 'package:nurulislam/pages/kegiatan.dart';
import 'package:nurulislam/screens/admin_screen.dart';
import 'package:nurulislam/screens/login_screen.dart';

void main() {
  //runApp(const MosqueApp());
  runApp(MaterialApp(
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
      //'/about': (context) => const aboutPage(),
      '/dkm': (context) => const dkm(),
      '/kegiatan': (context) => const kegiatan(),
      '/login': (context) => const LoginScreen(),
      '/admin': (context) => const AdminScreen(),
    },
  ));
}
