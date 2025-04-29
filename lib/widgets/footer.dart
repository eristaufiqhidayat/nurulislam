import 'package:flutter/material.dart';

class MosqueFooter extends StatelessWidget {
  const MosqueFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green[900],
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          const Text(
            'Masjid Nurul Islam',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pondok Kopi \n08118684222\ninfo@nurulislam.info',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            '© 2023 Masjid Nurul Islam. All rights reserved.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
