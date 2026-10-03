import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nurulislam/Home.dart';
import 'package:nurulislam/layouts/web_home_page.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';

class ResponsiveLayout extends StatelessWidget {
  final int initialIndex;

  const ResponsiveLayout({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useDesktopWeb = kIsWeb && width >= 900;

    if (useDesktopWeb) {
      return WebHomePage(initialIndex: initialIndex);
    }

    return Scaffold(
      appBar: MobileAppBar(),
      endDrawer: MobileDrawer(),
      body: HomePage(initialIndex: initialIndex),
    );
  }
}
