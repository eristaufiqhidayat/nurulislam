import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';
import 'package:nurulislam/widgets/header.dart';
import 'package:nurulislam/widgets/footer.dart';
import 'package:nurulislam/pages/pagecontent.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: isMobile ? MobileAppBar() : null,
      endDrawer: isMobile ? const MobileDrawer() : null,
      body: Column(
        children: [
          if (!isMobile) DesktopMenuBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const MosqueHeader(),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: PageContent(),
                  ),
                  const SizedBox(height: 40),
                  const MosqueFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
