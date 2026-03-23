import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
// import 'package:nurulislam/widgets/header.dart';
// import 'package:nurulislam/widgets/footer.dart';
// import 'package:nurulislam/widgets/menu_drawer.dart';

class dkm extends StatelessWidget {
  const dkm({super.key});

  Widget buildCard(String title, String content) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              content,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget verticalLine() {
    return Container(width: 2, height: 30, color: Colors.grey);
  }

  Widget horizontalLine(double width) {
    return Container(height: 2, width: width, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Struktur Organisasi"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// KETUA
              buildCard("KETUA", "M. HARIS"),

              verticalLine(),

              /// SEKRETARIS & BENDAHARA
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCard("SEKRETARIS", "1. M. ISYAK ST\n2. ARIO W"),
                  const SizedBox(width: 40),
                  buildCard("BENDAHARA", "1. RHEZA\n2. H KERRY"),
                ],
              ),

              verticalLine(),

              /// GARIS KE BAWAH
              horizontalLine(300),

              const SizedBox(height: 10),

              /// 4 BIDANG
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// BIDANG 1
                    Column(
                      children: [
                        buildCard("KETUA BIDANG 1", "SUYARTO"),
                        buildCard("SIE DAKWAH", "1. JAMALUDIN\n2. ANTARIKSO"),
                        buildCard("SIE MUSLIMAH", "1. MEITY W\n2. NENENG M"),
                      ],
                    ),

                    const SizedBox(width: 10),

                    /// BIDANG 2
                    Column(
                      children: [
                        buildCard("KETUA BIDANG II", "ERIS TAUFIQ HIDAYAT"),
                        buildCard(
                            "SIE EKONOMI SYARIAH", "1. BANU\n2. DWI HARSONO"),
                      ],
                    ),

                    const SizedBox(width: 10),

                    /// BIDANG 3
                    Column(
                      children: [
                        buildCard("KETUA BIDANG III", "RONI PASLA"),
                        buildCard("SIE PEMBANGUNAN FISIK", "RIAN"),
                        buildCard("SIE KEBERSIHAN", "1. MARULLAH\n2. MUKHLIS"),
                        buildCard(
                            "SIE KEAMANAN", "1. SUTARNO\n2. SANDY\n3. UNTUNG"),
                      ],
                    ),

                    const SizedBox(width: 10),

                    /// KOMUNIKASI
                    Column(
                      children: [
                        buildCard(
                            "BIDANG KOMUNIKASI", "1. SENO HENDRO\n2. HERRY S"),
                        buildCard("SIE PEMUDA", "AGUS HERNING PRAJA"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
