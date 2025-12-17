import 'package:flutter/material.dart';
// import 'package:nurulislam/pages/almawa/barang/barang_crud_page.dart';
//import 'package:nurulislam/pages/almawa/barang_masuk/barang_masuk_page.dart';
// import 'package:nurulislam/pages/almawa/barang_masuk/barang_masuk_inv.dart';
// import 'package:nurulislam/pages/almawa/harga/harga_page.dart';
// import 'package:nurulislam/pages/almawa/pembeli/pembeli_crud_page.dart';
//import 'package:nurulislam/pages/almawa/penjualan/detail_penjualan_page.dart';
//import 'package:nurulislam/pages/almawa/penjualan/penjualan_form_page.dart';
// import 'package:nurulislam/pages/almawa/penjualan/penjualan_page.dart';
// import 'package:nurulislam/pages/almawa/supplier/supplier_page.dart';
// import 'package:nurulislam/pages/menuRolepage.dart';
// import 'package:nurulislam/pages/page_info/page_info_crud.dart';
// import 'package:nurulislam/pages/pagecontent_crud/page_contetnt_crud.dart';
// import 'package:nurulislam/pages/rekap_page.dart';
// import 'package:nurulislam/pages/user_crud/user_page.dart';
//import 'package:nurulislam/widgets/menu_drawer.dart';
import '../models/user_model.dart';
import '../models/menu_model.dart';
import '../services/auth_service.dart';
import '../utils/shared_prefs.dart';
// import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  final User? user;
  const HomeScreen({Key? key, this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MenuItem>> _menuFuture;
  List<MenuItem> _menuItems = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.user?.token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    _menuFuture = AuthService.getUserMenu(widget.user!.role);
    _menuFuture.then((m) => setState(() => _menuItems = m));
  }

  Future<void> _logout() async {
    await SharedPrefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode
        ? ThemeData.dark().copyWith(primaryColor: Colors.green.shade800)
        : ThemeData.light().copyWith(primaryColor: Colors.green);

    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //drawer: MobileDrawer(),
        backgroundColor: Colors.green.shade50,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 🔹 Gambar background masjid
                    Image.asset(
                      'assets/images/masjid_nuris.jpg',
                      fit: BoxFit.cover,
                    ),

                    // 🔹 Overlay hijau transparan agar teks tetap terbaca
                    Container(
                      color: Colors.green.withOpacity(0.65),
                    ),

                    // 🔹 Konten di tengah (avatar, nama, dll)
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            child: Icon(Icons.person,
                                size: 35, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Assalamu'alaikum, ${widget.user!.name}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            "Dashboard",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white),
                    onPressed: () {}),
                IconButton(
                  icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white),
                  onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
                ),
                IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _logout),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(2),
              sliver: FutureBuilder<List<MenuItem>>(
                future: _menuFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  int crossAxis = MediaQuery.of(context).size.width > 1400
                      ? 10
                      : MediaQuery.of(context).size.width > 1200
                          ? 9
                          : MediaQuery.of(context).size.width > 900
                              ? 8
                              : MediaQuery.of(context).size.width > 600
                                  ? 5
                                  : 4;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxis,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1.25,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _menuIcon(_menuItems[i]),
                      childCount: _menuItems.length,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _menuIcon(MenuItem item) {
    final Color itemColor = _parseColor(item.color); // default hijau
    print(item.route);
    return InkWell(
      //onTap: () => _navigate(item),
      onTap: () {
        if (item.route.isNotEmpty) {
          Navigator.pushNamed(context, item.route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Route ${item.route} belum tersedia")));
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: itemColor
                  .withOpacity(0.15), // background lembut dari warna icon
            ),
            child: SizedBox(
              width: 50,
              height: 50,
              child: _icon(item.icon),
            ),
          ),
          const SizedBox(height: 3),
          SizedBox(
            width: 60,
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 9,
                color: itemColor, // warna teks sama dengan icon
                height: 1.1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // void _navigate(MenuItem item) {
  //   final pages = {
  //     '/admin': AdminScreen(),
  //     '/pagecontent_crud': pagecontent_crud(),
  //     '/menuRole': MenuRolePage(),
  //     '/pageInfo': PageInfoPage(),
  //     //'/barangMasuk': BarangMasukPage(),
  //     '/barangMasuk': BarangMasukInv(),
  //     '/barang': BarangPage(),
  //     '/pembeli': PembeliPage(),
  //     '/penjualan': PenjualanPage(),
  //     '/userCrud': UserPage(),
  //     '/hargaBarang': HargaPage(),
  //     '/rekapPenjualan': RekapPenjualanPage(),
  //     '/suppliers': SupplierPage(),
  //   };

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) =>
  //           pages[item.route] ??
  //           Scaffold(
  //               body: Center(
  //                   child: Text("Halaman ${item.route} belum tersedia"))),
  //     ),
  //   );
  // }

  Widget _icon(String urlOrAsset) {
    return _loadNetworkImage(urlOrAsset);
  }

  Widget _loadNetworkImage(String url) {
    return Image.network(
      url,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // 🔥 Tahap 2: fallback ke asset
        return _loadAssetImage(url);
      },
    );
  }

  Widget _loadAssetImage(String asset) {
    return Image.asset(
      "assets/images/$asset", // path lengkap ke asset,
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 40,
          height: 40,
          color: Colors.grey[300],
          child: const Icon(Icons.apps_rounded, size: 24),
        );
      },
    );
  }
}

Color _parseColor(String colorString) {
  try {
    if (colorString.startsWith('0x')) {
      return Color(int.parse(colorString));
    } else if (colorString.startsWith('#')) {
      String hex = colorString.substring(1);
      if (hex.length == 6) {
        hex = 'FF' + hex; // tambahkan alpha jika tidak ada
      }
      return Color(int.parse('0x$hex'));
    }
  } catch (e) {
    // Jika parsing gagal, kembalikan warna default
  }
  return Color(0xFF388E3C); // default hijau
}
