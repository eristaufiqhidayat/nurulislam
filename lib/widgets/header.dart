import 'package:flutter/material.dart';

class MosqueHeader extends StatelessWidget {
  const MosqueHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      height: isMobile ? 250 : 350,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/masjid_nuris.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[800]!.withOpacity(0.1),
              Colors.green[900]!.withOpacity(0.3),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mosque,
                color: Colors.white,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'MASJID NURUL ISLAM',
                style: TextStyle(
                  fontSize: isMobile ? 24 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pondok Kopi, Jakarta Timur',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Membangun Ummat, Memakmurkan Masjid',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}