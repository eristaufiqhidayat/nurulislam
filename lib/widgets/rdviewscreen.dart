// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RdViewScreen extends StatefulWidget {
  const RdViewScreen({super.key});

  //const RdViewScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RdViewScreenState createState() => _RdViewScreenState();
}

class _RdViewScreenState extends State<RdViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Inisialisasi WebViewController
    const PlatformWebViewControllerCreationParams params =
        PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(params);

    // Mengonfigurasi WebView
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://www.dakwah.id/artikel/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Back'),
        ),
        body: WebViewWidget(
          controller: _controller,
        ));
  }
}
