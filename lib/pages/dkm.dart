import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/header.dart';
import 'package:nurulislam/widgets/footer.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';

class dkm extends StatelessWidget {
  const dkm({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Scaffold(
      appBar: isMobile
          ? MobileAppBar(
              judul: "DKM",
            )
          : null,
      endDrawer: isMobile ? const MobileDrawer() : null,
      body: Column(
        children: [
          if (!isMobile)
            DesktopMenuBar(
              judul: "DKM",
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const MosqueHeader(),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Struktur Organisasi',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                )),
                        const SizedBox(height: 40),
                        Image.asset(
                          'assets/images/dkm_structure.jpg',
                        ),
                      ],
                    ),
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
