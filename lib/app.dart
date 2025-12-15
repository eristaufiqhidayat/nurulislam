import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nurulislam/Home.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';
import 'package:nurulislam/widgets/header.dart';
import 'package:nurulislam/widgets/footer.dart';
import 'package:nurulislam/pages/pagecontentWeb.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;

    return Scaffold(
      appBar: MobileAppBar(),
      endDrawer: MobileDrawer(),
      body: kIsWeb
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DesktopMenuBar(judul: 'Masjid Nurul Islam'),
                        const MosqueHeader(),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: PageContent(
                            screenWidth: screenWidth,
                            isMobile: isMobile,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const MosqueFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : HomePage(),
    );
  }
}
