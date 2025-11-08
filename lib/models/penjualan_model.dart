class PenjualanModel {
  final int? id;
  final int pembeliId;
  final DateTime tglTransaksi;

  PenjualanModel({
    this.id,
    required this.pembeliId,
    required this.tglTransaksi,
  });

  Map<String, dynamic> toJson() => {
        'pembeli_id': pembeliId,
        'tgl_transaksi': tglTransaksi.toIso8601String(),
      };

  factory PenjualanModel.fromJson(Map<String, dynamic> json) {
    // safe parsing: json may contain only some fields
    return PenjualanModel(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse('${json['id'] ?? ''}') ?? null),
      pembeliId: json['pembeli_id'] is int
          ? json['pembeli_id']
          : (int.tryParse('${json['pembeli_id'] ?? '0'}') ?? 0),
      tglTransaksi: json['tgl_transaksi'] != null
          ? DateTime.parse(json['tgl_transaksi'])
          : DateTime.now(),
    );
  }
}
