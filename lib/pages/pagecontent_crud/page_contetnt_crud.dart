import 'package:flutter/material.dart';
import 'package:nurulislam/models/pageinfo_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';

class pagecontent_crud extends StatefulWidget {
  const pagecontent_crud({super.key});

  @override
  State<pagecontent_crud> createState() => _pagecontent_crudState();
}

class _pagecontent_crudState extends State<pagecontent_crud> {
  // Example items list, replace with your actual data source or fetch logic
  final List<PageinfoModel> items = [];
  String? token;

  @override
  void initState() {
    super.initState();
    _initToken();
  }

  Future<void> _initToken() async {
    token = await SharedPrefs.getToken();
    print(token);
    if (token == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Page Content CRUD',
      ),
      body: items.isEmpty
          ? Center(child: Text('No items found'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    leading: item.imageUrl != null
                        ? Image.network(item.imageUrl!)
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
