// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nurulislam/features/tabunganqurban/pages/tabungan_form.dart';
import 'package:nurulislam/utils/auth_helper.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import '../services/tabungan_qurban_service.dart';
import '../models/tabungan_qurban_model.dart';
import 'tabungan_qurban_table_web.dart';
import 'tabungan_qurban_list_mobile.dart';

class TabunganQurbanPage extends StatefulWidget {
  const TabunganQurbanPage({super.key});

  @override
  State<TabunganQurbanPage> createState() => _TabunganQurbanPageState();
}

class _TabunganQurbanPageState extends State<TabunganQurbanPage> {
  final service = TabunganQurbanService();
  List<TabunganQurbanModel> data = [];
  bool loading = true;

  int page = 1;
  String search = '';
  String status = 'all';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      data = await service.fetchList(
        page: page,
      );
    } catch (e) {
      AuthHelper.handle401(context);
    }
    setState(() => loading = false);
  }

  void tabunganForm(bool isMobile) {
    isMobile
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TabunganFormPage(
                isMobile: isMobile,
              ),
            ),
          )
        : showDialog(
            context: context,
            barrierDismissible: false, // optional
            builder: (context) => TabunganFormPage(
              isMobile: isMobile,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: AppBarCustom(
        title: 'Tabungan Qurban',
        leading: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () async {
              await loadData();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tabunganForm(isMobile),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _filterBar(),
                Expanded(
                  child: isMobile
                      ? TabunganQurbanListMobile(data: data)
                      : TabunganQurbanTableWeb(data: data),
                ),
                _pagination(),
              ],
            ),
    );
  }

  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari nama jamaah...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) {
                search = v;
                loadData();
              },
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: status,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Semua')),
              DropdownMenuItem(value: 'aktif', child: Text('Aktif')),
              DropdownMenuItem(value: 'lunas', child: Text('Lunas')),
              DropdownMenuItem(value: 'batal', child: Text('Batal')),
            ],
            onChanged: (v) {
              status = v!;
              loadData();
            },
          )
        ],
      ),
    );
  }

  Widget _pagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: page > 1
              ? () {
                  page--;
                  loadData();
                }
              : null,
          icon: const Icon(Icons.chevron_left),
        ),
        Text('Page $page'),
        IconButton(
          onPressed: () {
            page++;
            loadData();
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
