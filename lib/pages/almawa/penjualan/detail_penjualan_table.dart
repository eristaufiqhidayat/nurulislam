import 'package:flutter/material.dart';
import '../../../models/detail_penjualan_model.dart';

class DetailPenjualanTable extends StatelessWidget {
  final List<DetailPenjualan> items;
  final void Function(DetailPenjualan) onEdit;
  final void Function(DetailPenjualan) onDelete;

  const DetailPenjualanTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final green = Colors.green.shade700;
    final lightGreen = Colors.green.shade50;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: green.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              WidgetStateProperty.all(green), // header background hijau
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          dataTextStyle: TextStyle(
            color: Colors.green.shade800,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          dividerThickness: 0.8,
          columnSpacing: 20,
          horizontalMargin: 16,
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Penjualan ID')),
            DataColumn(label: Text('Barang')),
            DataColumn(label: Text('Jumlah')),
            DataColumn(label: Text('Harga Jual')),
            DataColumn(label: Text('Harga Beli')),
            DataColumn(label: Text('Margin')),
            DataColumn(label: Text('Aksi')),
          ],
          rows: items
              .map(
                (d) => DataRow(
                  color: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return lightGreen.withOpacity(0.4);
                      }
                      return items.indexOf(d) % 2 == 0
                          ? Colors.white
                          : lightGreen.withOpacity(0.3);
                    },
                  ),
                  cells: [
                    DataCell(Text(d.id?.toString() ?? '-')),
                    DataCell(Text(d.penjualanId?.toString() ?? '-')),
                    DataCell(Text(d.barang?.namaBarang ?? '-')),
                    DataCell(Text(d.jumlah.toString())),
                    DataCell(Text("Rp ${d.hargaJual.toStringAsFixed(0)}")),
                    DataCell(Text("Rp ${d.hargaBeli.toStringAsFixed(0)}")),
                    DataCell(Text("Rp ${d.margin.toStringAsFixed(0)}")),
                    DataCell(Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Edit Data",
                          child: IconButton(
                            icon:
                                Icon(Icons.edit, color: Colors.green.shade600),
                            onPressed: () => onEdit(d),
                          ),
                        ),
                        Tooltip(
                          message: "Hapus Data",
                          child: IconButton(
                            icon: Icon(Icons.delete_forever_rounded,
                                color: Colors.red.shade400),
                            onPressed: () => onDelete(d),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
