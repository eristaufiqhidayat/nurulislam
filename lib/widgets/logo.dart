// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MosqueLogo extends StatelessWidget {
  final bool compact;
  String? judul;

  MosqueLogo({super.key, this.compact = false, this.judul});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Icon(
          Icons.mosque,
          color: Colors.white,
          size: compact ? 24 : 32,
        ),
        const SizedBox(width: 8),
        Text(
          judul ?? "Home",
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 16 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
