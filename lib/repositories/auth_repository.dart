import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nurulislam/config/api_constants.dart';
import 'package:nurulislam/models/menu_model.dart';
import 'package:nurulislam/models/pageinfo_model.dart';
import 'package:nurulislam/models/user_model.dart';
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

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/login'),
        body: {
          'email': email,
          'password': password,
        },
      );
      //print('Response status: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //print("auth_service : $data");
        return User.fromJson(data);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  static Future<List<MenuItem>> getUserMenu(String role) async {
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

  static Future<User?> getUser() async {
    final user = await SharedPrefs.getUser();
    return user;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPrefs.getToken();
    return prefs != null;
  }

  static Future<void> logout() async {
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

  Future<List<PageinfoModel>> fetchPosts(String category) async {
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
      print("API GAGAL");
      // ❌ API gagal → ambil dari SQLite
    }

    return await getByCategory(category);
  }
}
