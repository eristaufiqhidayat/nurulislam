// ignore_for_file: file_names
// test

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nurulislam/pages/pagecontentMobile.dart';
import 'package:nurulislam/pages/product/product_list_card.dart';
import 'package:nurulislam/screens/home_screen.dart';
import 'package:nurulislam/screens/surah_list.dart';
import 'package:nurulislam/widgets/haditsviewscreen.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';
import 'package:nurulislam/widgets/rdviewscreen.dart';
//import 'package:nurulislam/widgets/rdviewscreen.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//         home: NavigationExample(), debugShowCheckedModeBanner: false);
//   }
// }

class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  //late String alamatweb;
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialIndex; // ✅ PENTING
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBarCustom(
      //   title: 'Nuris',
      //   showBack: false,
      //   leading: [
      //     AppBarCustom.cartIcon(context),
      //   ],
      // ),
      endDrawer: MobileDrawer(),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: CurvedNavigationBar(
          animationCurve: Curves.easeInOutBack,
          index: currentPageIndex,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: <Widget>[
            FaIcon(FontAwesomeIcons.house, size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.bookQuran, size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.bookOpen, size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.calendarCheck,
                size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.list, size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.person, size: 30, color: Colors.white),
          ],
          color: Colors.green,
          backgroundColor: Colors.white,
          height: 60.0,
        ),
      ),

      //endDrawer: MobileDrawer(),
      body: <Widget>[
        PageContentMobile(),
        SurahListPage(),
        HaditsViewScreen(),
        RdViewScreen(),
        ProductListPage(),
        DashBoard(),
      ][currentPageIndex],
    );
  }
}
