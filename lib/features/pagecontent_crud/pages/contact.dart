import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // buka google maps
  void openMaps() async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=Masjid+Nurul+Islam+Pondok+Kopi");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // buka whatsapp
  void openWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/6281234567890");
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // buka email
  void openEmail() async {
    final Uri url = Uri.parse("mailto:info@nurulislam.info");
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Kontak',
        routeName: '/homepage',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Text(
              "Hubungi Kami",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Masjid Nurul Islam Pondok Kopi",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 20),

            // CARD ALAMAT
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.green[700], size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Jl. Arabika VII No.9 Blok Y9, RT.10/RW.6, '
                            'Pd. Kopi, Kec. Duren Sawit, Jakarta Timur 13460',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: openMaps,
                        icon: const Icon(Icons.map),
                        label: const Text("Buka Maps"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CARD KONTAK
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          Icon(Icons.phone, color: Colors.green[700], size: 28),
                      title: const Text("WhatsApp"),
                      subtitle: const Text("+62 812-3456-7890"),
                      onTap: openWhatsApp,
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.email, color: Colors.green[700], size: 28),
                      title: const Text("Email"),
                      subtitle: const Text("info@nurulislam.info"),
                      onTap: openEmail,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // FOOTER
            Center(
              child: Text(
                "© 2025 Masjid Nurul Islam",
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
