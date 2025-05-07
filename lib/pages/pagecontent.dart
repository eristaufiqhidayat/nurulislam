import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  PageContent({super.key});

  final List<Map<String, dynamic>> myItems = [
    {
      'title': 'Shalat Berjamaah',
      'description': 'Shalat 5 waktu berjamaah setiap hari',
      'image': 'assets/images/kajian1.jpg',
    },
    {
      'title': 'Pengajian',
      'description': 'Kajian rutin setiap pekan',
      'icon': Icons.menu_book,
    },
  ];

  final List<Map<String, dynamic>> qurbanItems = [
    {
      'title': 'Sapi Bali',
      'description': 'Patungan 1 Sapi 7 Orang',
      'image': 'assets/images/qurbanSapi.jpg',
    },
  ];
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
              height: 500, // or use Expanded if in a Column with other widgets
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: qurbanItems.length,
                itemBuilder: (context, index) {
                  final item = qurbanItems[index];
                  return SizedBox(
                    width: 430,
                    child: QurbanImage(
                      title: item['title'],
                      description: item['description'],
                      assetPath: item['image'],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Kajian',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 399, // or use Expanded if in a Column with other widgets
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myItems.length,
                itemBuilder: (context, index) {
                  final item = myItems[index];
                  return SizedBox(
                    width: 200,
                    child: KajianCard(
                      assetPath: item['image'],
                      title: item['title'],
                      description: item['description'],
                    ),
                  );
                },
              ),
            ),
            // Option 1: Using GridView (recommended for this layout)
            // GridView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: myItems.length,
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: MediaQuery.of(context).size.width < 750 ? 1 : 3,
            //     crossAxisSpacing: 20,
            //     mainAxisSpacing: 20,
            //     childAspectRatio: 1.2,
            //   ),
            //   itemBuilder: (context, index) {
            //     final item = myItems[index];
            //     return FeatureCard(
            //       icon: item['icon'],
            //       title: item['title'],
            //       description: item['description'],
            //     );
            //   },
            // ),

            // Option 2: If you prefer ListView (for vertical scrolling)
          ],
        ),
      ),
    );
  }
}

class QurbanImage extends StatelessWidget {
  final String assetPath;
  final String title;
  final String description;

  const QurbanImage({
    super.key,
    required this.assetPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.green[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              assetPath,
              //height: 160,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    height: 1.5,
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

class KajianCard extends StatelessWidget {
  final String? assetPath;
  final String title;
  final String description;

  const KajianCard({
    super.key,
    this.assetPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    print(assetPath);
    return Card(
      elevation: 4,
      color: Colors.green[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          assetPath != null
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    assetPath!,
                    width: 200,
                    //height: 160,
                    //fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    height: 1.5,
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
