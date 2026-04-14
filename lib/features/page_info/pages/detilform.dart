// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, non_constant_identifier_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
//import 'package:nurulislam/api/auth_service.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
//import 'package:sentraextro/widget/appbar_widget.dart';
import 'package:nurulislam/widgets/textCaption1_widget.dart';
import 'package:nurulislam/widgets/textTitle1_widget.dart';
import 'package:flutter/foundation.dart';

class DetilForm1 extends StatefulWidget {
  final dynamic data;
  final dynamic columnn;
  final List<Map<String, dynamic>>? datacolumn;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onDelete;
  final Function(Map<String, dynamic>)? onInsert;
  final Future<void> Function()? onRefresh;
  final String? mode;

  // ignore: use_key_in_widget_constructors
  DetilForm1(
      {this.data,
      this.columnn,
      this.datacolumn,
      this.onEdit,
      this.onDelete,
      this.onInsert,
      this.onRefresh,
      this.mode});

  @override
  _DetilForm1State createState() => _DetilForm1State();
}

class _DetilForm1State extends State<DetilForm1> {
  Map<String, String>? dataColumn = {};
  Map<String, dynamic> _data = {};
  Map<String, TextEditingController> _controllers = {};
  bool _isedit = false;
  String? _jenisKelamin;
  Map<String, String>? ToMap(var dataColoumn) {
    return {
      for (var item in dataColoumn)
        item.keys.first: item.values.first.toString()
    };
  }

  @override
  void initState() {
    super.initState();
    _data = widget.data ?? {};
    dataColumn = ToMap(widget.datacolumn ?? []);
    _controllers = {
      for (var entry in _data.entries)
        entry.key: TextEditingController(text: entry.value.toString())
    };
    if (widget.mode == "insert") {
      dataColumn?.remove("id");
      dataColumn?.remove("no");
      _controllers.remove("id");
      _controllers.remove("no");
      _data.remove("no");
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    double tinggi = 0;
    List<String> status = ["close", "open"];
    if (kIsWeb) {
      tinggi = 0;
    }
    return Scaffold(
      appBar: AppBarCustom(
        //routeName: "/mainmenu",
        title: "Data Siswa",
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: tinggi,
              ),
              TitleCustom1(
                text: "Data Siswa Daftar",
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 400,
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   border: Border.all(
                  //     color: Colors.grey, // Warna border
                  //     width: 1.5, // Ketebalan border
                  //   ),
                  //   borderRadius: BorderRadius.circular(12), // Radius sudut
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        border: TableBorder.all(
                          color: Colors.grey, // Warna garis
                          width: 1.0, // Ketebalan garis
                          style: BorderStyle
                              .solid, // Tipe garis (solid/dashed dll, default: solid)
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(0.4),
                          1: FlexColumnWidth(1.0),
                        },
                        children: _data.entries.map((entry) {
                          final label = dataColumn?[entry.key] ?? entry.key;
                          return TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              child: CaptionCustom1(text: label),
                            ),
                            entry.key == "image"
                                ? Image.network(
                                    "https://your-backend.com/storage/${entry.value}",
                                    height: 80,
                                  )
                                : _isedit
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: entry.key == 'status'
                                            ? _buildDropdownField(
                                                "Status", status, entry.key)
                                            : entry.key == 'tanggal'
                                                ? _buildDateField(label,
                                                    _controllers[entry.key]!)
                                                : TextFormField(
                                                    controller:
                                                        _controllers[entry.key],
                                                    style: TextStyle(
                                                      fontSize:
                                                          12, // 👈 ini untuk mengecilkan font
                                                      color: Colors
                                                          .black, // opsional, bisa diatur juga warnanya
                                                    ),
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 4),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        borderSide: BorderSide(
                                                            color: Colors.blue,
                                                            width: 2),
                                                      ),
                                                    ),
                                                  ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: 20,
                                            child:
                                                Text(entry.value.toString())),
                                      ),
                          ]);
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _isedit
                            ? [
                                ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Colors.white, // Warna teks dan ikon
                                    side: const BorderSide(
                                        color: Colors.blue), // Warna border
                                    backgroundColor: Colors
                                        .blue, // (opsional) warna latar belakang
                                  ),
                                  onPressed: () async {
                                    Map<String, dynamic> convertToMap(
                                        Map<String, TextEditingController>
                                            controllers) {
                                      return controllers.map(
                                          (key, controller) =>
                                              MapEntry(key, controller.text));
                                    }

                                    Map<String, dynamic> finalData =
                                        convertToMap(_controllers);

                                    bool result = true;
                                    // await AuthService.checkTokenAndRedirect(
                                    //     context);
                                    if (result) {
                                      try {
                                        //print('FinalData : ${widget.mode}');
                                        if (widget.mode == "insert") {
                                          //print(finalData);
                                          result = widget.onInsert!(finalData);
                                        } else {
                                          result = widget.onEdit!(finalData);
                                        }
                                      } catch (e) {
                                        print(
                                            "$e data_siswa_sm_form.dart gagal");
                                      }
                                    }
                                  },
                                  child: const Text("Simpan"),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Colors.black, // Warna teks dan ikon
                                    side: const BorderSide(
                                        color: Colors.yellow), // Warna border
                                    backgroundColor: Colors
                                        .yellow, // (opsional) warna latar belakang
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Batal"),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor:
                                        Colors.white, // Warna teks dan ikon
                                    side: const BorderSide(
                                        color: Colors.red), // Warna border
                                    backgroundColor: Colors
                                        .red, // (opsional) warna latar belakang
                                  ),
                                  onPressed: () async {
                                    Map<String, dynamic> convertToMap(
                                        Map<String, TextEditingController>
                                            controllers) {
                                      return controllers.map(
                                          (key, controller) =>
                                              MapEntry(key, controller.text));
                                    }

                                    Map<String, dynamic> finalData =
                                        convertToMap(_controllers);

                                    try {
                                      final result =
                                          widget.onDelete!(finalData);
                                      if (result == true) {
                                        if (!mounted) return;
                                        Navigator.pop(context,
                                            true); // ⬅️ penting: beri sinyal ke halaman sebelumnya
                                      } else {
                                        print(
                                            "gagal update data_siswa_sm_form.dart");
                                      }
                                    } catch (e) {
                                      print("$e data_siswa_sm_form.dart gagal");
                                    }
                                  },
                                  child: const Text("Delete"),
                                ),
                              ]
                            : [
                                IconButton(
                                  iconSize: 24.0,
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                IconButton(
                                  iconSize: 24.0,
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      _isedit = true;
                                    });
                                  },
                                ),
                              ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label tidak boleh kosong data_siswa_sm_form.dart";
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> items, var data) {
    _jenisKelamin = _controllers[data]?.text;
    _jenisKelamin = _jenisKelamin?.toLowerCase();

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      initialValue: _jenisKelamin,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _jenisKelamin = value;
          _controllers[data]?.text = _jenisKelamin!;
          print(_controllers[data]);
        });
      },
      validator: (value) =>
          value == null ? "$label harus dipilih data_siswa_sm_form.dart" : null,
    );
  }
}
