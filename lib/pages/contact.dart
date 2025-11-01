import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class contact extends StatelessWidget {
  const contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Home',
        routeName: '/homepage',
      ),
      body: Container(
        child: Center(
          child: Text(
            'Jl. Arabika VII No.9 Blok Y9, RT.10/RW.6, Pd. Kopi, Kec. Duren Sawit, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13460',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
        ),
      ),
    );
  }
}
