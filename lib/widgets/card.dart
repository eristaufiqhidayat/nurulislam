import 'package:flutter/material.dart';

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
    //print(assetPath);
    return Card(
      elevation: 4,
      color: Colors.green[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.green, // Border color
          width: 2.0,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                assetPath,
                //width: 50,
                //height: 160,
                fit: BoxFit.cover,
              ),
              // child: Image.asset(
              //   assetPath,
              //   //height: 160,
              //   fit: BoxFit.cover,
              // ),
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
    int maxLength = 50;

    String hasil = description.length > maxLength
        ? description.substring(0, maxLength)
        : description;
    //print(assetPath);
    return Card(
      elevation: 4,
      color: Colors.green[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.green, // Border color
          width: 2.0,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            assetPath != null
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      assetPath!,
                      //width: 50,
                      height: 250,
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
                        fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasil,
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
      ),
    );
  }
}
