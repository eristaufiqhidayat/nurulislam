import 'package:flutter/material.dart';
import 'package:nurulislam/features/page_info/models/pageinfo_model.dart';
import 'package:nurulislam/features/pagecontent_crud/pages/kajian_detil_crud.dart';
import 'package:nurulislam/features/register/services/auth_service.dart';
import 'package:nurulislam/widgets/card.dart';

class WebKegiatanPage extends StatefulWidget {
  const WebKegiatanPage({super.key});

  @override
  State<WebKegiatanPage> createState() => _WebKegiatanPageState();
}

class _WebKegiatanPageState extends State<WebKegiatanPage> {
  late final Future<List<PageinfoModel>> _kegiatanItems;

  @override
  void initState() {
    super.initState();
    _kegiatanItems = ApiService().fetchPosts('kegiatan');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PageinfoModel>>(
      future: _kegiatanItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final items = snapshot.data ?? const <PageinfoModel>[];
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada data kegiatan'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1200
                ? 4
                : constraints.maxWidth >= 850
                    ? 3
                    : 2;

            return GridView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.25,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KajianDetailPage(kajian: item),
                    ),
                  ),
                  child: KajianCard(
                    title: item.title,
                    description: item.description,
                    assetPath: item.image,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
