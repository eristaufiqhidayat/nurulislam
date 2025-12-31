import 'package:flutter/material.dart';
import '../../models/tabungan_qurban_model.dart';
import 'dialog_setoran.dart';

class TabunganQurbanListMobile extends StatelessWidget {
  final List<TabunganQurbanModel> data;

  const TabunganQurbanListMobile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (_, i) {
        final e = data[i];
        final progress = e.totalSetoran / e.targetNominal;

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text('Jamaah #${e.jamaah?.name}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rp ${e.totalSetoran} / ${e.targetNominal}'),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress > 1 ? 1 : progress),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => DialogSetoran(tabunganId: e.id),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
