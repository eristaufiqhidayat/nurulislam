import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nurulislam/features/pagecontent_crud/pages/pagecontentMobile.dart';
import 'package:nurulislam/features/product/pages/product_list_card.dart';
import 'package:nurulislam/screens/home_screen.dart';
import 'package:nurulislam/screens/surah_list.dart';
import 'package:nurulislam/widgets/haditsviewscreen.dart';
import 'package:nurulislam/widgets/rdviewscreen.dart';

class WebHomePage extends StatefulWidget {
  final int initialIndex;

  const WebHomePage({super.key, this.initialIndex = 0});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  late int currentIndex;

  static const _titles = <String>[
    'Beranda',
    'Al-Qur\'an',
    'Hadits',
    'Kegiatan',
    'Koperasi',
    'Akun',
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex.clamp(0, _titles.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      PageContentMobile(),
      SurahListPage(),
      HaditsViewScreen(),
      RdViewScreen(),
      ProductListPage(),
      const DashBoard(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => setState(() => currentIndex = index),
            extended: MediaQuery.sizeOf(context).width >= 1180,
            minExtendedWidth: 220,
            backgroundColor: const Color(0xFF166534),
            indicatorColor: Colors.white.withOpacity(.16),
            selectedIconTheme: const IconThemeData(color: Colors.white),
            unselectedIconTheme: const IconThemeData(color: Color(0xFFD1FAE5)),
            selectedLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelTextStyle: const TextStyle(color: Color(0xFFD1FAE5)),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mosque, color: Colors.white, size: 30),
                  if (MediaQuery.sizeOf(context).width >= 1180) ...[
                    const SizedBox(width: 10),
                    const Text(
                      'Nurul Islam',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(FontAwesomeIcons.house),
                label: Text('Beranda'),
              ),
              NavigationRailDestination(
                icon: Icon(FontAwesomeIcons.bookQuran),
                label: Text('Al-Qur\'an'),
              ),
              NavigationRailDestination(
                icon: Icon(FontAwesomeIcons.bookOpen),
                label: Text('Hadits'),
              ),
              NavigationRailDestination(
                icon: Icon(FontAwesomeIcons.calendarCheck),
                label: Text('Kegiatan'),
              ),
              NavigationRailDestination(
                icon: Icon(FontAwesomeIcons.store),
                label: Text('Koperasi'),
              ),
              NavigationRailDestination(
                icon: Icon(FontAwesomeIcons.user),
                label: Text('Akun'),
              ),
            ],
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _titles[currentIndex],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF14532D),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1400),
                      child: SizedBox.expand(child: pages[currentIndex]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
