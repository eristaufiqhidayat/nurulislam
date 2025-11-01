import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nurulislam/models/pageinfo_model.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class KajianDetailPage extends StatelessWidget {
  final PageinfoModel kajian;

  const KajianDetailPage({super.key, required this.kajian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Home',
        routeName: '/homepage',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar kajian
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                width:200,
                kajian.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // Judul
            Text(
              kajian.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
            ),
            const SizedBox(height: 10),

            // Markdown untuk deskripsi
            MarkdownBody(
              data: kajian.description,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, height: 1.6),
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                blockquote: TextStyle(
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTapLink: (text, href, title) {
                if (href != null) {
                  // buka link di browser
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
