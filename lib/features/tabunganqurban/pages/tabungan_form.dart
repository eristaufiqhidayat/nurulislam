import 'package:flutter/material.dart';
import 'package:nurulislam/features/tabunganqurban/services/tabungan_qurban_service.dart';
import 'package:nurulislam/features/user_crud/services/user_service.dart';
import 'package:nurulislam/widgets/appbar_widget.dart';
import 'package:nurulislam/widgets/dropdown_search_map.dart';

class TabunganFormPage extends StatefulWidget {
  final bool isMobile;

  const TabunganFormPage({
    super.key,
    required this.isMobile,
  });

  @override
  State<TabunganFormPage> createState() => _TabunganFormPageState();
}

class _TabunganFormPageState extends State<TabunganFormPage> {
  final _namaCtrl = TextEditingController();
  final _tahunCtrl = TextEditingController();
  final _hewanCtrl = TextEditingController();
  final _nominalCtrl = TextEditingController();
  Map<String, dynamic>? _selectedUser;
  final _serviceUser = UserService();
  final _serviceTabungan = TabunganQurbanService();

  void save() {
    print('User    : ${_selectedUser?['id'].toString()}');
    _serviceTabungan.create(
      {
        'jamaahId': _selectedUser?['id'],
        'tahunQurban': int.tryParse(_tahunCtrl.text) ?? 0,
        'targetHewan': _hewanCtrl.text,
        'targetNominal': double.tryParse(_nominalCtrl.text) ?? 0.0,
        'totalSetoran': 0.0,
        'status': 'aktif',
      },
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _tahunCtrl.dispose();
    _hewanCtrl.dispose();
    _nominalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isMobile
        ? Scaffold(
            appBar: AppBarCustom(title: 'Tambah Tabungan Jamaah'),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: _form(),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: save,
              label: const Text('Simpan'),
              icon: const Icon(Icons.save),
            ),
          )
        : AlertDialog(
            title: const Text('Tambah Tabungan Jamaah'),
            content: SizedBox(
              width: 400,
              child: _form(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: save,
                child: const Text('Simpan'),
              ),
            ],
          );
  }

  Widget _dropdownsearch() {
    return DropdownSearchMap(
      fetchData: _serviceUser.fetchUsersmap,
      selectedItem: _selectedUser,
      label: 'Pilih Jamaah',
      icon: Icons.person,
      onChanged: (val) {
        setState(() => _selectedUser = val);
      },
      validator: (v) => v == null ? 'Nama Jamaah wajib dipilih' : null,
    );
  }

  Widget _form() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dropdownsearch(),
        TextField(
          controller: _tahunCtrl,
          decoration: const InputDecoration(labelText: 'Tahun Qurban'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _hewanCtrl,
          decoration: const InputDecoration(labelText: 'Target Hewan'),
        ),
        TextField(
          controller: _nominalCtrl,
          decoration: const InputDecoration(labelText: 'Target Nominal'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
