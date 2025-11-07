import 'package:flutter/material.dart';
import '../../../models/detail_penjualan_model.dart';

class DetailPenjualanTable extends StatelessWidget {
  final List<DetailPenjualan> items;
  final void Function(DetailPenjualan) onEdit;
  final void Function(DetailPenjualan) onDelete;

  const DetailPenjualanTable(
      {required this.items, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Barang')),
          DataColumn(label: Text('Jumlah')),
          DataColumn(label: Text('Harga Jual')),
          DataColumn(label: Text('Harga Beli')),
          DataColumn(label: Text('Margin')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: items
            .map((d) => DataRow(cells: [
                  DataCell(Text(d.id?.toString() ?? '-')),
                  DataCell(Text(d.barang?.namaBarang ?? '-')),
                  DataCell(Text(d.jumlah.toString())),
                  DataCell(Text(d.hargaJual.toStringAsFixed(2))),
                  DataCell(Text(d.hargaBeli.toStringAsFixed(2))),
                  DataCell(Text(d.margin.toStringAsFixed(2))),
                  DataCell(Row(children: [
                    IconButton(
                        icon: Icon(Icons.edit), onPressed: () => onEdit(d)),
                    IconButton(
                        icon: Icon(Icons.delete), onPressed: () => onDelete(d)),
                  ]))
                ]))
            .toList(),
      ),
    );
  }
}
