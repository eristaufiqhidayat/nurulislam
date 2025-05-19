import 'package:flutter/material.dart';

final List<MenuEntry> menuItems = [
  MenuEntry('Home', Icons.home, '/'),
  //MenuEntry('About us', Icons.info, '/about'),
  MenuEntry('DKM', Icons.info, '/dkm'),
  MenuEntry('Kegiatan', Icons.event, '/kegiatan'),
  MenuEntry('Donasi', Icons.volunteer_activism, '/donate'),
  MenuEntry('Kontak', Icons.contact_page, '/contact'),
  MenuEntry('Login', Icons.contact_page, '/login'),
];

class MenuEntry {
  final String title;
  final IconData icon;
  final String route;

  MenuEntry(this.title, this.icon, this.route);
}
