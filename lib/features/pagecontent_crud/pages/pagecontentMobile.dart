import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/pageinfo_model.dart';
import 'package:nurulislam/features/product/pages/product_list_home.dart';
import 'package:nurulislam/features/register/services/auth_service.dart';
import 'package:nurulislam/features/pagecontent_crud/pages/kajian_detil_crud.dart';
import 'package:nurulislam/widgets/card.dart';

class PageContentMobile extends StatefulWidget {
  final double? screenWidth;
  final bool? isMobile;
  const PageContentMobile({super.key, this.screenWidth, this.isMobile});

  @override
  _PageContentMobileState createState() => _PageContentMobileState();
}

class _PageContentMobileState extends State<PageContentMobile> {
  late Future<List<PageinfoModel>> qurbanItems;
  late Future<List<PageinfoModel>> kegiatanItems;
  late Future<List<PageinfoModel>> kajianItems;

  final PageController qurbanController = PageController(viewportFraction: 1.1);
  Timer? qurbanTimer;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    qurbanItems = ApiService().fetchPosts('qurban');
    kegiatanItems = ApiService().fetchPosts('kegiatan');
    kajianItems = ApiService().fetchPosts('kajian');
  }

  @override
  void dispose() {
    qurbanTimer?.cancel();
    qurbanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final bool isMobile = widget.isMobile ?? true;
    double scale = 0.7;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductListHome(), //<---- ditambahkan di sini

            Text(
              'Sekilas Info',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // NEW SIZE
                  ),
            ),
            const SizedBox(height: 8),

            // ================= SLIDER QURBAN ==================

            SizedBox(
              width: 800 * scale,
              height: 600 * scale,
              child: FutureBuilder<List<PageinfoModel>>(
                future: qurbanItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada data Qurban');
                  }

                  final items = snapshot.data!;
                  final itemCount = items.length;

                  if (!_timerStarted) {
                    _startAutoSlide(itemCount);
                    _timerStarted = true;
                  }

                  return PageView.builder(
                    controller: qurbanController,
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return AnimatedBuilder(
                        animation: qurbanController,
                        builder: (context, child) {
                          double value = 1.0;

                          try {
                            if (qurbanController.position.haveDimensions) {
                              final page = qurbanController.page ??
                                  qurbanController.initialPage.toDouble();
                              value = (1 - ((page - index).abs() * 0.3))
                                  .clamp(0.7, 1.0);
                            }
                          } catch (_) {}

                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KajianDetailPage(kajian: item),
                              ),
                            );
                          },
                          child: containerItem(item),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // ================= KEGIATAN ==================
            Text(
              'Kegiatan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // NEW SIZE
                  ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              //aspectRatio: 14 / 3,
              height: 300,
              //width: 300,
              // NEW SIZE lebih proporsional
              child: FutureBuilder<List<PageinfoModel>>(
                future: kegiatanItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada data kegiatan');
                  }
                  final items = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return SizedBox(
                        width: 230, // NEW SIZE
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KajianDetailPage(kajian: item),
                              ),
                            );
                          },
                          child: KajianCard(
                            title: item.title,
                            description: item.description,
                            assetPath: item.image,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // ================= KAJIAN ==================
            Text(
              'Kajian',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // NEW SIZE
                  ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 300, // NEW SIZE
              child: FutureBuilder<List<PageinfoModel>>(
                future: kajianItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Tidak ada data kajian');
                  }
                  final items = snapshot.data!;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return SizedBox(
                        width: 230, // NEW SIZE
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KajianDetailPage(kajian: item),
                              ),
                            );
                          },
                          child: KajianCard(
                            title: item.title,
                            description: item.description,
                            assetPath: item.image,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= AUTO SLIDER ==================
  void _startAutoSlide(int itemCount) {
    qurbanTimer?.cancel();
    if (itemCount <= 1) return;

    qurbanTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      final currentPage = qurbanController.hasClients
          ? (qurbanController.page?.round() ?? qurbanController.initialPage)
          : qurbanController.initialPage;

      int nextPage = currentPage + 1;
      if (nextPage >= itemCount) nextPage = 0;

      if (qurbanController.hasClients) {
        qurbanController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // ================= CARD SLIDER (QURBAN) ==================
  Widget containerItem(PageinfoModel item) {
    final assetPath2 =
        ApiConstants.getFullImageUrl('storage/uploads/${item.image}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              assetPath2,
              //item.image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image, size: 40)),
            ),

            // GRADIENT AGAR TEKS LEBIH JELAS
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // TEXT TITLE
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17, // NEW SIZE
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
