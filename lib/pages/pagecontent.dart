import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/card.dart';

class PageContent extends StatelessWidget {
  final screenWidth;
  final isMobile;
  PageContent({super.key, this.screenWidth, this.isMobile});

  final List<Map<String, dynamic>> myItems = [
    {
      'title': 'Tafsir Surat Alfatihah',
      'description': 'Mengkaji Tafsir Surat Alfatihah',
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
      'title': 'Sapi Bali dan Kambing',
      'description':
          'Patungan 1 Sapi 7 Orang, perorang Rp. 3.5 Juta                                         '
              '1 Kambing Rp. 3.5 Juta',
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
              height: isMobile
                  ? 500
                  : 800, // or use Expanded if in a Column with other widgets
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: qurbanItems.length,
                itemBuilder: (context, index) {
                  final item = qurbanItems[index];
                  return SizedBox(
                    width: isMobile ? 430 : 800,
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
            const SizedBox(height: 10),
            SizedBox(
              height: 370, // or use Expanded if in a Column with other widgets
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
