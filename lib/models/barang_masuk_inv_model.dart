import 'package:nurulislam/models/supplier_model.dart';
import 'barang_masuk_model.dart';

class BarangMasukInvModel {
  final int? id;
  final int idSupplier;
  final DateTime tanggal;
  final SupplierModel? supplier;
  final List<BarangMasukModel>? barangMasuk; // opsional jika API memakai relasi

  BarangMasukInvModel({
    this.id,
    required this.idSupplier,
    required this.tanggal,
    this.supplier,
    this.barangMasuk,
  });

  factory BarangMasukInvModel.fromJson(Map<String, dynamic> json) {
    return BarangMasukInvModel(
      id: json['id'],
      idSupplier: json['id_supplier'],
      tanggal: DateTime.parse(json['tanggal']),
      supplier: json['supplier'] != null
          ? SupplierModel.fromJson(json['supplier'])
          : null,
      barangMasuk: json['barang_masuk'] != null
          ? (json['barang_masuk'] as List)
              .map((e) => BarangMasukModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_supplier': idSupplier,
      'tanggal': tanggal.toIso8601String(),
      if (supplier != null) 'supplier': supplier!.toJson(),
    };
  }
}
