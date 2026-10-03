import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/features/page_info/models/pageinfo_model.dart';
import 'package:nurulislam/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'content_repository.dart';

class ContentManagementPage extends StatefulWidget {
  final String category;
  const ContentManagementPage({super.key, required this.category});
  @override
  State<ContentManagementPage> createState() => _ContentManagementPageState();
}

class _ContentManagementPageState extends State<ContentManagementPage> {
  late final ContentRepository _repository;
  late Future<List<PageinfoModel>> _items;
  String _search = '';
  bool _deleting = false;
  bool _loaded = false;
  String get _label => widget.category == 'kegiatan' ? 'Kegiatan' : 'Kajian';

  @override
  void initState() {
    super.initState();
    _repository = ContentRepository(widget.category);
    _items = Future.value(<PageinfoModel>[]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loggedIn = context.watch<AuthProvider>().isLoggedIn;
    if (loggedIn && !_loaded) {
      _loaded = true;
      _items = _repository.list();
    } else if (!loggedIn) {
      _loaded = false;
    }
  }

  void _reload() => setState(() { _items = _repository.list(); });
  void _message(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _edit([PageinfoModel? item]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ContentForm(repository: _repository, label: _label, item: item),
    );
    if (!mounted || saved != true) return;
    _message('$_label berhasil disimpan.');
    _reload();
  }

  Future<void> _delete(PageinfoModel item) async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text('Hapus $_label?'),
      content: Text('Hapus “${item.title}”? Data yang dihapus tidak dapat dikembalikan.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus'))],
    ));
    if (!mounted || confirmed != true) return;
    setState(() => _deleting = true);
    try {
      await _repository.delete(item.id!);
      if (!mounted) return;
      _message('$_label berhasil dihapus.');
      _reload();
    } catch (e) {
      if (mounted) _message(e.toString());
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AuthProvider>().isLoggedIn;
    return Scaffold(
      appBar: AppBar(title: Text('Kelola $_label'), actions: [if (loggedIn) IconButton(tooltip: 'Muat ulang', onPressed: _deleting ? null : _reload, icon: const Icon(Icons.refresh))]),
      floatingActionButton: loggedIn ? FloatingActionButton.extended(onPressed: _deleting ? null : () => _edit(), icon: const Icon(Icons.add), label: Text('Tambah $_label')) : null,
      body: !loggedIn ? Center(child: FilledButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: const Text('Silakan login'))) : Center(
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1000), child: Column(children: [
          Padding(padding: const EdgeInsets.all(16), child: TextField(onChanged: (value) => setState(() => _search = value.toLowerCase()), decoration: InputDecoration(labelText: 'Cari $_label', prefixIcon: const Icon(Icons.search), border: const OutlineInputBorder()))),
          if (_deleting) const LinearProgressIndicator(),
          Expanded(child: FutureBuilder<List<PageinfoModel>>(future: _items, builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Padding(padding: const EdgeInsets.all(16), child: Text('${snapshot.error}', textAlign: TextAlign.center)), FilledButton(onPressed: _reload, child: const Text('Coba lagi'))]));
            final items = (snapshot.data ?? []).where((e) => '${e.title} ${e.description}'.toLowerCase().contains(_search)).toList();
            if (items.isEmpty) return Center(child: Text(_search.isEmpty ? 'Belum ada ${widget.category}. Tekan Tambah $_label.' : 'Tidak ada hasil pencarian.'));
            return ListView.builder(padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), itemCount: items.length, itemBuilder: (context, index) {
              final item = items[index];
              return Card(child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
                SizedBox(width: 64, height: 64, child: item.image.isEmpty ? const Icon(Icons.image_outlined) : Image.network(_imageUrl(item.image), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis)])),
                IconButton(tooltip: 'Edit', onPressed: _deleting ? null : () => _edit(item), icon: const Icon(Icons.edit_outlined)),
                IconButton(tooltip: 'Hapus', onPressed: _deleting ? null : () => _delete(item), icon: const Icon(Icons.delete_outline, color: Colors.red)),
              ])));
            });
          })),
        ])),
      ),
    );
  }
}

String _imageUrl(String image) => ApiConstants.getFullImageUrl(image.startsWith('http') || image.startsWith('storage/') ? image : 'storage/uploads/$image');

class _ContentForm extends StatefulWidget {
  final ContentRepository repository;
  final String label;
  final PageinfoModel? item;
  const _ContentForm({required this.repository, required this.label, this.item});
  @override
  State<_ContentForm> createState() => _ContentFormState();
}

class _ContentFormState extends State<_ContentForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late String _image;
  PlatformFile? _file;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.item?.title ?? '');
    _description = TextEditingController(text: widget.item?.description ?? '');
    _image = widget.item?.image ?? '';
  }
  @override
  void dispose() { _title.dispose(); _description.dispose(); super.dispose(); }

  Future<void> _pick() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'], withData: true);
      if (!mounted || result == null) return;
      final file = result.files.single;
      if (file.size > 2 * 1024 * 1024 || file.bytes == null) {
        setState(() => _error = 'Pilih gambar maksimal 2 MB.');
        return;
      }
      setState(() { _file = file; _error = null; });
    } catch (e) { if (mounted) setState(() => _error = '$e'); }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _saving = true; _error = null; });
    try {
      if (_file != null) {
        _image = await widget.repository.upload(_file!);
        _file = null;
      }
      await widget.repository.save(PageinfoModel(id: widget.item?.id, title: _title.text.trim(), description: _description.text.trim(), image: _image, icon: widget.item?.icon ?? '', category: widget.repository.category));
      if (mounted) Navigator.pop(context, true);
    } catch (e) { if (mounted) setState(() => _error = '$e'); }
    finally { if (mounted) setState(() => _saving = false); }
  }

  @override
  Widget build(BuildContext context) => PopScope(canPop: !_saving, child: AlertDialog(
    title: Text('${widget.item == null ? 'Tambah' : 'Edit'} ${widget.label}'),
    content: SizedBox(width: 560, child: SingleChildScrollView(child: Form(key: _form, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextFormField(controller: _title, enabled: !_saving, maxLength: 255, decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()), validator: (value) => value == null || value.trim().isEmpty ? 'Judul wajib diisi.' : null),
      const SizedBox(height: 12),
      TextFormField(controller: _description, enabled: !_saving, minLines: 4, maxLines: 8, decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder())),
      const SizedBox(height: 16),
      if (_file?.bytes != null) Image.memory(_file!.bytes!, height: 160, fit: BoxFit.contain)
      else if (_image.isNotEmpty) Image.network(_imageUrl(_image), height: 160, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Text('Gambar tidak dapat dimuat.')),
      Wrap(spacing: 8, children: [OutlinedButton.icon(onPressed: _saving ? null : _pick, icon: const Icon(Icons.upload), label: const Text('Pilih gambar')),
        if (_file != null || _image.isNotEmpty) TextButton(onPressed: _saving ? null : () => setState(() { _file = null; _image = ''; }), child: const Text('Hapus gambar'))]),
      const Text('JPG, PNG, GIF, WEBP · maksimal 2 MB', style: TextStyle(fontSize: 12)),
      if (_error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: const TextStyle(color: Colors.red))),
      if (_saving) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
    ])))),
    actions: [TextButton(onPressed: _saving ? null : () => Navigator.pop(context, false), child: const Text('Batal')), FilledButton(onPressed: _saving ? null : _save, child: Text(_saving ? 'Menyimpan…' : 'Simpan'))],
  ));
}
