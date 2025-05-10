import 'package:flutter/material.dart';
import 'package:nurulislam/models/pageinfo_model.dart';
import 'package:nurulislam/services/pageinfo_api.dart';
import 'package:nurulislam/widgets/card.dart';

class PageContent extends StatefulWidget {
  final screenWidth;
  final isMobile;
  const PageContent({super.key, this.screenWidth, this.isMobile});

  @override
  _PageContentState createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
  late Future<List<PageinfoModel>> qurbanItems;
  late Future<List<PageinfoModel>> kegiatanItems;
  late Future<List<PageinfoModel>> kajianItems;

  void initState() {
    super.initState();
    qurbanItems = ApiService().fetchPosts('qurban');
    kegiatanItems = ApiService().fetchPosts('kegiatan');
    kajianItems = ApiService().fetchPosts('kajian');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Masjid Nurul Islam adalah pusat kegiatan keislaman yang berlokasi di Pondok Kopi. '
              'Kami menyelenggarakan berbagai kegiatan ibadah, pendidikan, dan sosial untuk umat.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 30),
            Text(
              'Info Qurban',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: widget.isMobile
                  ? 800
                  : 1000, // or use Expanded if in a Column with other widgets
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
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return SizedBox(
                          width: widget.isMobile ? 430 : 600,
                          child: QurbanImage(
                            title: item.title,
                            description: item.description,
                            assetPath: "assets/images/${item.image}",
                          ),
                        );
                      },
                    );
                  }),
            ),
            const SizedBox(height: 30),
            Text(
              'Kegiatan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 370, // or use Expanded if in a Column with other widgets
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
                          width: 200,
                          child: KajianCard(
                            title: item.title,
                            description: item.description,
                            assetPath: "assets/images/${item.image}",
                          ),
                        );
                      },
                    );
                  }),
            ),
            const SizedBox(height: 30),
            Text(
              'Kajian',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 370, // or use Expanded if in a Column with other widgets
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
                          width: 200,
                          child: KajianCard(
                            title: item.title,
                            description: item.description,
                            assetPath: "assets/images/${item.image}",
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
