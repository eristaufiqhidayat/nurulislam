import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  PageContent({super.key});

  final List<Map<String, dynamic>> myItems = [
    {
      'title': 'Shalat Berjamaah',
      'description': 'Shalat 5 waktu berjamaah setiap hari',
      'icon': Icons.mosque,
    },
    {
      'title': 'Pengajian',
      'description': 'Kajian rutin setiap pekan',
      'icon': Icons.menu_book,
    },
    {
      'title': 'Kegiatan Sosial',
      'description': 'Bakti sosial masyarakat sekitar',
      'icon': Icons.people,
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
              'Info Kegiatan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200, // or use Expanded if in a Column with other widgets
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myItems.length,
                itemBuilder: (context, index) {
                  final item = myItems[index];
                  return SizedBox(
                    width: 200,
                    child: InfoCard(
                      //icon: item['icon'],
                      title: item['title'],
                      description: item['description'],
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
              height: 200, // or use Expanded if in a Column with other widgets
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: myItems.length,
                itemBuilder: (context, index) {
                  final item = myItems[index];
                  return SizedBox(
                    width: 200,
                    child: InfoCard(
                      //icon: item['icon'],
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

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.green[700],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;

  const InfoCard({
    super.key,
    this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon(
            //   icon,
            //   size: 40,
            //   color: Colors.green[700],
            // ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.green,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
