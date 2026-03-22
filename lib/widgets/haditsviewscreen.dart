// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HaditsViewScreen extends StatefulWidget {
  const HaditsViewScreen({super.key});

  //const HaditsViewScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HaditsViewScreenState createState() => _HaditsViewScreenState();
}

class _HaditsViewScreenState extends State<HaditsViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _openWeb(); // 🔥 langsung buka tab baru
    } else {
      const PlatformWebViewControllerCreationParams params =
          PlatformWebViewControllerCreationParams();

      _controller = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse('https://hadits.tazkia.ac.id/'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
      ),
      body: kIsWeb
          ? const Center(
              child: Text('Membuka halaman...'),
            )
          : WebViewWidget(controller: _controller),
    );
  }

  void _openWeb() async {
    final url = Uri.parse('https://hadits.tazkia.ac.id/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
