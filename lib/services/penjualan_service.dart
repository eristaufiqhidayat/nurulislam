import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/repositories/penjualan_repository.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import '../config/api_constants.dart';
import '../models/penjualan_model.dart';

class PenjualanService {
  // from api_constants.dart
  final _repo = PenjualanRepository();
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<PenjualanModel> create(PenjualanModel p) async {
    return await _repo.create(p);
  }

  Future<List<PenjualanModel>> fetchPenjualan() {
    //final headers = await _headers();
    return _repo.fetchPenjualan();
  }

  Future<PenjualanModel> fetchPenjualanBy(id) async {
    return await _repo.fetchPenjualanBy(id);
  }

  Future<bool> deletePenjualan(int id) async {
    return await _repo.deletePenjualan(id);
  }
}
