// ignore_for_file: unused_element

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/features/menus/models/menu_model.dart';
import 'package:nurulislam/features/page_info/models/pageinfo_model.dart';
import 'package:nurulislam/features/user_crud/models/user_model.dart';
import 'package:nurulislam/utils/shared_prefs.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthRepository {
  static Future<Map<String, String>> _headers() async {
    final token = await SharedPrefs.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
    required String no_hp,
  }) async {
    final res =
        await http.post(Uri.parse('${ApiConstants.baseUrl}/api/register'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'password_confirmation': password,
              'role_id': role,
              'no_hp': no_hp,
            }));
    //final data = jsonDecode(res.body);
    print('Register response: ${res.body} ');
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Gagal register / Email sudah terdaftar');
    }
    //var token = res['token']; // ✅ AUTO LOGIN
  }

  Future<void> resendOtp({
    required String email,
  }) async {
    final res =
        await http.post(Uri.parse('${ApiConstants.baseUrl}/api/resend-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email}));
    print('Register response: ${res.body} ');
    //var token = res['token']; // ✅ AUTO LOGIN
  }

  Future<User> verifyOtp(String email, String otp) async {
    final res =
        await http.post(Uri.parse('${ApiConstants.baseUrl}/api/verify-otp'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'otp': otp,
            }));
    print('Verify OTP response: ${res.body}');
    return User.fromJson(json.decode(res.body));
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer TOKEN_LOGIN',
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah password');
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/login'),
        body: {
          'email': email,
          'password': password,
        },
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 205) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: ${e.toString()}');
    }
  }

  Future<List<MenuItem>> getUserMenu(String role) async {
    try {
      final token = await SharedPrefs.getToken();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/menu?token=$token&role=$role'),
        body: {
          'role': role,
          'token': token ?? '',
        },
      );
      //print(response.body);
      //print('${ApiConstants.baseUrl}/api/menu?token=$token&role=$role');
      if (response.statusCode == 200) {
        //print("Raw JSON: ${response.body}");
        final List<dynamic> data = json.decode(response.body);

        //print("Parsed JSON: $data");
        return data
            .map<MenuItem>(
                (item) => MenuItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load menu: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading menu auth_service: $e');
    }
  }

  Future<User?> getUser() async {
    final user = await SharedPrefs.getUser();
    return user;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPrefs.getToken();
    return prefs != null;
  }

  Future<void> logout() async {
    // ignore: unused_local_variable
    final prefs = await SharedPrefs.clear();
  }
}

class ApiRepository {
  static Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  // 🔥 DATABASE DIBUAT DI SINI
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nurulislam.db');
    print(path);

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pageinfo (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            image TEXT NOT NULL,
            icon TEXT,
            category TEXT NOT NULL,
            created_at TEXT,
            updated_at TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ⬅️ dipanggil SAAT version naik
        if (oldVersion < 3) {
          await db.execute('''
          DROP TABLE IF EXISTS categories
        ''');
        }
      },
    );
  }

  Future<List<PageinfoModel>> getByCategory(String category) async {
    final db = await database;

    final result = await db.query(
      'pageinfo',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'id DESC',
    );

    return result.map((e) => PageinfoModel.fromJson(e)).toList();
  }

  Future<void> upsertAll(List<PageinfoModel> list) async {
    final db = await database;

    final batch = db.batch();

    for (var item in list) {
      batch.insert(
        'pageinfo',
        item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<PageinfoModel>> fetchPostsBak(String category) async {
    try {
      final url = Uri.parse(
        "${ApiConstants.baseUrl}/api/pageinfo?category=$category",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);

        final posts =
            jsonData.map((item) => PageinfoModel.fromJson(item)).toList();

        await upsertAll(posts);
        return posts;
      }
    } catch (_) {
      print('${ApiConstants.baseUrl}/api/pageinfo?category=$category');
      print("API GAGAL");
      // ❌ API gagal → ambil dari SQLite
    }

    return await getByCategory(category);
  }

  Future<List<PageinfoModel>> fetchPosts(String category) async {
    try {
      final url =
          Uri.parse("${ApiConstants.baseUrl}/api/pageinfo?category=$category");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List jsonData = json.decode(response.body);

        final posts =
            jsonData.map((item) => PageinfoModel.fromJson(item)).toList();

        // ❗ hanya simpan ke SQLite jika bukan Web
        if (!kIsWeb) {
          await upsertAll(posts);
        }

        return posts;
      }
    } catch (_) {
      print("API GAGAL");
    }

    // ❗ Web tidak punya SQLite
    if (kIsWeb) {
      return [];
    }

    return await getByCategory(category);
  }
}
