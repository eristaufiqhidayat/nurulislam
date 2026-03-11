import 'package:flutter/material.dart';
//import '../models/user_model.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: const Center(
        child: Text('This is the admin panel'),
      ),
    );
  }
}
