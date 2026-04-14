// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurulislam/config/theme_config.dart';
import 'package:nurulislam/features/page_info/pages/detilform.dart';

class CustomTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final List<Map<String, dynamic>> properties;
  final List<String> columnTitle;
  final List<String> columnNames;
  final List<double> columnWidths;
  final int rowsPerPage;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;
  final double fontSize;
  final List<Map<String, dynamic>>? DataColumn;
  final Future<void> Function()? onRefresh;

  const CustomTable({
    super.key,
    required this.data,
    this.properties = const [],
    this.columnTitle = const [],
    required this.columnNames,
    required this.columnWidths,
    required this.onEdit,
    required this.onDelete,
    this.rowsPerPage = 5,
    this.fontSize = 11,
    this.DataColumn,
    this.onRefresh,
  });

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    int totalPages = max(1, (widget.data.length / widget.rowsPerPage).ceil());

    // Tambahkan kolom "Aksi" ke columnTitle agar sejajar dengan columnNames
    List<String> columnTitles = widget.columnTitle.isNotEmpty
        ? [...widget.columnTitle, "Aksi"]
        : [...widget.columnNames, "Aksi"];
    var currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    // Data yang akan ditampilkan sesuai halaman saat ini
    List<Map<String, dynamic>> visibleData = widget.data
        .skip(_currentPage * widget.rowsPerPage)
        .take(widget.rowsPerPage)
        .toList();
    final lebarLayar = MediaQuery.of(context).size.width;
    // print("table_widget.dart  lebar layar : $lebarLayar");
    // double total = widget.columnWidths.reduce((a, b) => a + b);

    // print("count(widget.columnWidths) : $total");
    if (widget.columnWidths.length != columnTitles.length) {
      throw Exception(
          "${widget.columnWidths.length} Jumlah columnWidths tidak sesuai dengan jumlah columnTitles! ${columnTitles.length}");
    }
    return Column(
      children: [
        // Container agar tabel tetap proporsional
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: lebarLayar,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(ThemeConfig.sentraextro),
                columnSpacing: 5,
                border: TableBorder.all(color: Colors.grey), // Tambahkan border
                columns: columnTitles
                    .map((name) => DataColumn(
                          label: SizedBox(
                            width: widget
                                    .columnWidths[columnTitles.indexOf(name)] *
                                lebarLayar,
                            child: Text(
                              name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 23, 17, 176)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                    .toList(),
                rows: visibleData.isNotEmpty
                    ? visibleData
                        .map(
                          (row) => DataRow(
                            cells: [
                              // Menampilkan data berdasarkan columnNames
                              ...widget.columnNames.map((colName) => DataCell(
                                    Align(
                                      alignment: widget.properties.isNotEmpty &&
                                              widget.properties[0][colName]
                                                      .toString() ==
                                                  "currency"
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: widget.properties.isNotEmpty &&
                                              widget.properties[0][colName]
                                                      .toString() ==
                                                  "currency"
                                          ? Text(
                                              currencyFormatter
                                                  .format(row[colName] ?? 0),
                                              style: TextStyle(
                                                color:
                                                    Colors.black, // Warna biru
                                                fontWeight: FontWeight
                                                    .bold, // Teks bold
                                                fontSize: widget
                                                    .fontSize, // Ukuran font bisa disesuaikan
                                              ),
                                            )
                                          : Text(
                                              row[colName].toString(),
                                              style: TextStyle(
                                                color:
                                                    Colors.black, // Warna biru
                                                fontWeight: FontWeight
                                                    .bold, // Teks bold
                                                fontSize: widget
                                                    .fontSize, // Ukuran font bisa disesuaikan
                                              ),
                                            ),
                                    ),
                                  )),
                              // Kolom aksi (Edit & Delete)
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.visibility,
                                          color: Colors.blue,
                                        ),
                                        iconSize: 15.0,
                                        onPressed: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetilForm1(
                                                data: row,
                                                columnn: widget.columnTitle,
                                                datacolumn: widget.DataColumn,
                                                onEdit: widget.onEdit,
                                                onDelete: widget.onDelete,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        iconSize: 15.0,
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => widget.onEdit(row),
                                      ),
                                      IconButton(
                                        iconSize: 15.0,
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => widget.onDelete(row),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList()
                    : [
                        DataRow(
                          cells: List.generate(columnTitles.length, (index) {
                            return index == columnTitles.length - 1
                                ? const DataCell(
                                    SizedBox()) // Kosong untuk kolom "Aksi"
                                : const DataCell(
                                    Center(
                                      child: Text(
                                        "Tidak ada data",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  );
                          }),
                        ),
                      ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Pagination Controls (hanya tampil jika ada lebih dari 1 halaman)
        if (widget.data.length > widget.rowsPerPage)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
                child: const Text("Previous"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("Page ${_currentPage + 1} of $totalPages"),
              ),
              ElevatedButton(
                onPressed: (_currentPage < totalPages - 1)
                    ? () => setState(() => _currentPage++)
                    : null,
                child: const Text("Next"),
              ),
            ],
          ),
      ],
    );
  }
}
