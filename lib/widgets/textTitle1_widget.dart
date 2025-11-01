// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TitleCustom1 extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontFamily;

  const TitleCustom1(
      {super.key,
      required this.text,
      this.fontSize = 20,
      this.fontFamily = "Roboto" // Default ukuran font
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black, // Warna biru
          fontWeight: FontWeight.bold, // Teks bold
          fontSize: fontSize,
          fontFamily: fontFamily // Ukuran font bisa disesuaikan
          ),
    );
  }
}
