import 'package:flutter/material.dart';

class KajianCard extends StatelessWidget {
  final String title;
  final String description;
  final String assetPath;

  const KajianCard({
    Key? key,
    required this.title,
    required this.description,
    required this.assetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // ====== FULL IMAGE ======
            Positioned.fill(
              child: Image.network(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),

            // ====== OVERLAY HIJAU FIX HEIGHT ======
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 70, // <<=========== FIXED HEIGHT
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.65),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center, // biar tengah vertical
                  children: [
                    // TITLE
                    Text(
                      title,
                      maxLines: 1, // karena tinggi fix
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // DESCRIPTION
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
