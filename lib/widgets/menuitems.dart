import 'package:flutter/material.dart';

final List<MenuEntry> menuItems = [
  MenuEntry('Home', Icons.home, '/'),
  //MenuEntry('About us', Icons.info, '/about'),
  MenuEntry('DKM', Icons.info, '/dkm'),
  MenuEntry('Kegiatan', Icons.event, '/kegiatan'),
  MenuEntry('Donasi', Icons.volunteer_activism, '/donasi'),
  MenuEntry('Kontak', Icons.contact_page, '/contact'),
  MenuEntry('Version Software', Icons.computer_sharp, '/version_software'),
  MenuEntry('Login', Icons.login, '/login'),
];

class MenuEntry {
  final String title;
  final IconData icon;
  final String route;

  MenuEntry(this.title, this.icon, this.route);
}
