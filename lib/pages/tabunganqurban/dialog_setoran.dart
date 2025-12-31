import 'package:flutter/material.dart';
import '../../services/tabungan_qurban_service.dart';

class DialogSetoran extends StatefulWidget {
  final int? tabunganId;
  const DialogSetoran({super.key, this.tabunganId});

  @override
  State<DialogSetoran> createState() => _DialogSetoranState();
}

class _DialogSetoranState extends State<DialogSetoran> {
  final service = TabunganQurbanService();
  final nominal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Setoran'),
      content: TextField(
        controller: nominal,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Nominal'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        ElevatedButton(
          onPressed: () async {
            await service.addSetoran(
              tabunganId: widget.tabunganId!,
              tanggal: DateTime.now().toIso8601String().substring(0, 10),
              nominal: double.parse(nominal.text),
              metode: 'cash',
            );
            Navigator.pop(context);
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
