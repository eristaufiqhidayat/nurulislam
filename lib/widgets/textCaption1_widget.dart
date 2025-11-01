// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CaptionCustom1 extends StatelessWidget {
  final String text;
  final double fontSize;

  const CaptionCustom1({
    super.key,
    required this.text,
    this.fontSize = 11, // Default ukuran font
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black, // Warna biru
            fontWeight: FontWeight.bold, // Teks bold
            fontSize: fontSize, // Ukuran font bisa disesuaikan
          ),
        ),
      ),
    );
  }
}
