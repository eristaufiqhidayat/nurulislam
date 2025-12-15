import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nurulislam/pages/pagecontentMobile.dart';
import 'package:nurulislam/screens/surah_list.dart';
import 'package:nurulislam/widgets/haditsviewscreen.dart';
import 'package:nurulislam/widgets/rdviewscreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: NavigationExample(), debugShowCheckedModeBanner: false);
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});
  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample>
    with SingleTickerProviderStateMixin {
  late String alamatweb;
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: CurvedNavigationBar(
          animationCurve: Curves.easeInOutBack,
          index: 0,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const <Widget>[
            FaIcon(FontAwesomeIcons.house, size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.bookQuran, size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.bookOpen, size: 30, color: Colors.white),
            FaIcon(FontAwesomeIcons.calendarCheck,
                size: 30, color: Colors.white)
          ],
          color: Colors.green,
          backgroundColor: Colors.white,
          height: 60.0,
        ),
      ),

      //endDrawer: MobileDrawer(),
      body: <Widget>[
        const PageContentMobile(),
        SurahListPage(),
        HaditsViewScreen(),
        RdViewScreen(),
      ][currentPageIndex],
    );
  }
}
