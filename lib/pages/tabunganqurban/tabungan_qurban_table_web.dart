import 'package:flutter/material.dart';
import '../../models/tabungan_qurban_model.dart';
import 'dialog_setoran.dart';

class TabunganQurbanTableWeb extends StatelessWidget {
  final List<TabunganQurbanModel> data;

  const TabunganQurbanTableWeb({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
        columns: const [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Tahun')),
          DataColumn(label: Text('Target')),
          DataColumn(label: Text('Terkumpul')),
          DataColumn(label: Text('Progress')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: data.map((e) {
          final progress = e.totalSetoran / e.targetNominal;

          return DataRow(cells: [
            DataCell(Text('Jamaah #${e.jamaahId}')),
            DataCell(Text(e.tahunQurban.toString())),
            DataCell(Text('Rp ${e.targetNominal}')),
            DataCell(Text('Rp ${e.totalSetoran}')),
            DataCell(
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  backgroundColor: Colors.grey.shade300,
                  color: progress >= 1 ? Colors.green : Colors.orange,
                ),
              ),
            ),
            DataCell(Chip(
              label: Text(e.status),
              backgroundColor: _statusColor(e.status),
            )),
            DataCell(
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => DialogSetoran(tabunganId: e.id),
                  );
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'lunas':
        return Colors.green.shade200;
      case 'batal':
        return Colors.red.shade200;
      default:
        return Colors.orange.shade200;
    }
  }
}
