// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:nurulislam/widgets/logo.dart';
import 'package:nurulislam/widgets/menuitems.dart';

class DesktopMenuBar extends StatelessWidget {
  String? judul;
  DesktopMenuBar({super.key, this.judul});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[800],
        // border: Border.all(
        //   color: Colors.black, // Border color
        //   width: 2.0, // Border width
        // ),
      ),
      //color: Colors.green[800],
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.black, // Border color
            //     width: 0, // Border width
            //   ),
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MosqueLogo(judul: this.judul),
              ],
            ),
          ),
          Container(
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.black, // Border color
            //     width: 0, // Border width
            //   ),
            // ),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...menuItems.map((item) => MenuButton(item: item)).toList(),
                // const SizedBox(width: 20),
                // Flexible(
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.green[600],
                //       foregroundColor: Colors.white,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(20),
                //       ),
                //     ),
                //     onPressed: () {
                //       // Action for donation button
                //     },
                //     child: const Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //       child: Text('Donasi Sekarang'),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final MenuEntry item;

  const MenuButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(
              context, '${item.route.toLowerCase()}'); // Navigation action
        },
        child: Text(
          item.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? judul;
  MobileAppBar({super.key, this.judul});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[800],
      title: MosqueLogo(
        compact: true,
        judul: this.judul,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: false,
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    );
  }
}

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green[700],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MosqueLogo(),
                SizedBox(height: 10),
                Text(
                  'Masjid Nurul Islam',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ...menuItems.map((item) => ListTile(
                leading: Icon(item.icon, color: Colors.green[700]),
                title: Text('${item.title}'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, '${item.route.toLowerCase()}');
                  // Navigation action
                },
              )),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                // Donation action
              },
              child: const Text('Donasi Sekarang'),
            ),
          ),
        ],
      ),
    );
  }
}
