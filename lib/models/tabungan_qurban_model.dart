import 'package:nurulislam/models/jamaah_model.dart';
import 'tabungan_qurban_detail_model.dart';

class TabunganQurbanModel {
  final int id;
  final int jamaahId;
  final int tahunQurban;
  final String targetHewan;
  final double targetNominal;
  final double totalSetoran;
  final String status;
  final List<TabunganQurbanDetailModel> detail;
  final JamaahModel? jamaah;

  TabunganQurbanModel({
    required this.id,
    required this.jamaahId,
    required this.tahunQurban,
    required this.targetHewan,
    required this.targetNominal,
    required this.totalSetoran,
    required this.status,
    required this.detail,
    this.jamaah,
  });

  factory TabunganQurbanModel.fromJson(Map<String, dynamic> json) {
    return TabunganQurbanModel(
      id: int.parse(json['id'].toString()),
      jamaahId: int.parse(json['jamaah_id'].toString()),
      tahunQurban: int.parse(json['tahun_qurban'].toString()),
      targetHewan: json['target_hewan'].toString(),
      targetNominal: double.parse(json['target_nominal'].toString()),
      totalSetoran: double.parse(json['total_setoran'].toString()),
      status: json['status'].toString(),
      jamaah:
          json['jamaah'] != null ? JamaahModel.fromJson(json['jamaah']) : null,
      detail: json['detail'] != null
          ? (json['detail'] as List)
              .map((e) => TabunganQurbanDetailModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
