import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'nurulislam.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE pageinfo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          image TEXT NOT NULL,
          icon TEXT,
          category TEXT NOT NULL CHECK (
            category IN ('qurban', 'kegiatan', 'kajian', 'taksin')
          ),
          created_at TEXT,
          updated_at TEXT
        )
        ''');
      },
    );
  }

  // ================= CRUD =================

  Future<int> insert(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      'pageinfo',
      {
        ...data,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return await db.query(
      'pageinfo',
      orderBy: 'id DESC',
    );
  }

  Future<int> update(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'pageinfo',
      {
        ...data,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'pageinfo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clear() async {
    final db = await database;
    await db.delete('pageinfo');
  }
}
