import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/header.dart';
import 'package:nurulislam/widgets/footer.dart';
import 'package:nurulislam/widgets/menu_drawer.dart';

class kegiatan extends StatelessWidget {
  const kegiatan({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Scaffold(
      appBar: isMobile
          ? MobileAppBar(
              judul: "Kegiatan",
            )
          : null,
      endDrawer: isMobile ? const MobileDrawer() : null,
      body: Column(
        children: [
          if (!isMobile)
            DesktopMenuBar(
              judul: "Kegiatan",
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
                      children: [
                        const Text('Kegiatan',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DKM adalah singkatan dari Dewan Kemakmuran Masjid, yaitu sebuah organisasi yang bertanggung jawab dalam mengelola dan memakmurkan masjid. DKM memiliki peran penting dalam merencanakan, mengoordinasikan, serta mengawasi kegiatan-kegiatan ibadah dan sosial yang berlangsung di masjid, termasuk pengelolaan keuangan, pemeliharaan fasilitas, serta program-program keagamaan dan pendidikan yang diselenggarakan untuk masyarakat.'
                                'Secara umum, tugas dan tanggung jawab DKM mencakup:',
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '- Pengelolaan Ibadah: Mengatur jadwal sholat, khutbah, pengajian, dan acara keagamaan lainnya.',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '- Pemeliharaan Fasilitas Masjid: Memastikan kebersihan, keamanan, dan pemeliharaan bangunan masjid.',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '- Kegiatan Sosial dan Pendidikan: Mengadakan program seperti pengajian, pendidikan agama, kegiatan sosial, serta pemberdayaan masyarakat.',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '- Pengelolaan Dana dan Infaq: Mengatur penerimaan dan penggunaan dana masjid secara transparan dan akuntabel.',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'DKM berfungsi sebagai lembaga yang memastikan masjid tidak hanya menjadi tempat ibadah, tetapi juga pusat kegiatan sosial, pendidikan, dan pembinaan umat.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
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
