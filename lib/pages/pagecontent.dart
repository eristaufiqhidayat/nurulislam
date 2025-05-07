import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/card.dart';

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
          ],
        ),
      ),
    );
  }
}
