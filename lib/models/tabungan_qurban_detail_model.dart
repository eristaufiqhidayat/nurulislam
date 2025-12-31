class TabunganQurbanDetailModel {
  final int id;
  final int tabunganId;
  final String tanggal;
  final double nominal;
  final String metode;
  final String? keterangan;

  TabunganQurbanDetailModel({
    required this.id,
    required this.tabunganId,
    required this.tanggal,
    required this.nominal,
    required this.metode,
    this.keterangan,
  });

  factory TabunganQurbanDetailModel.fromJson(Map<String, dynamic> json) {
    return TabunganQurbanDetailModel(
      id: json['id'],
      tabunganId: json['tabungan_id'],
      tanggal: json['tanggal'],
      nominal: double.parse(json['nominal'].toString()),
      metode: json['metode'],
      keterangan: json['keterangan'],
    );
  }
}
