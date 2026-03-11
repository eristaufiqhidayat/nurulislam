import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/barang_harga_model.dart';

class HargaTableWidget extends StatelessWidget {
  final List<BarangHarga> items;
  final Function(BarangHarga) onEdit;
  final Function(int) onDelete;

  const HargaTableWidget({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatTanggal(String tanggal) {
    try {
      final date = DateTime.parse(tanggal);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return tanggal; // fallback kalau gagal parse
    }
  }

  String _formatCurrency(num value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowMinHeight: 28, // 👈 tinggi baris minimal
      dataRowMaxHeight: 36, // 👈 tinggi baris maksimal
      columnSpacing: 10, // 👈 jarak antar kolom lebih rapat
      headingRowHeight: 36, // 👈 tinggi header
      border: TableBorder.all(
        color: Colors.grey.shade400,
        width: 1,
      ), // 👉 jarak antar kolom (default 56)
      headingRowColor:
          WidgetStatePropertyAll(Colors.green.shade700.withOpacity(0.2)),

      columns: const [
        DataColumn(label: Text("ID")),
        DataColumn(label: Text("Nama Barang")),
        DataColumn(label: Text("Tanggal")),
        DataColumn(label: Text("Harga Beli")),
        DataColumn(label: Text("Harga Jual")),
        DataColumn(label: Text("Aksi")),
      ],
      rows: items.map((e) {
        return DataRow(cells: [
          DataCell(Text(e.id.toString())),
          DataCell(Text(e.barang?.namaBarang ?? '-')),
          DataCell(Text(_formatTanggal(e.tanggal))),
          DataCell(Text(_formatCurrency(e.hargaBeli))),
          DataCell(Text(_formatCurrency(e.hargaJual))),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onEdit(e),
              ),
              const SizedBox(width: 4), // 👈 jarak kecil antar ikon
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => onDelete(e.id!),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}
