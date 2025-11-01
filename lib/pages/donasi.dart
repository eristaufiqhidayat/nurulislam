import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class donasi extends StatelessWidget {
  const donasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Home',
        routeName: '/homepage',
      ),
      body: Container(
        child: Center(
          child: Image.network(
              'https://www.nurulislam.info/storage/pageinfo/donasi.jpeg'),
        ),
      ),
    );
  }
}
