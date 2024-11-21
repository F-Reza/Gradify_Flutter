import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/course.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'gradify.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseName TEXT NOT NULL,
        creditHours INTEGER NOT NULL,
        grade REAL NOT NULL,
        semester INTEGER NOT NULL
      )
    ''');
  }

  Future<List<Course>> getCoursesForAllSemesters() async {
    final db = await database;
    final result = await db.query('courses');
    return result.map((e) => Course.fromMap(e)).toList();
  }

  Future<List<Course>> getCourses(int semester) async {
    final db = await database;
    final result = await db.query(
      'courses',
      where: 'semester = ?',
      whereArgs: [semester],
      orderBy: 'id DESC',
    );
    return result.map((e) => Course.fromMap(e)).toList();
  }

  Future<int> insertCourse(Course course) async {
    final db = await database;
    return await db.insert('courses', course.toMap());
  }

  Future<int> deleteCourse(int id) async {
    final db = await database;
    return await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCourse(Course course) async {
    final db = await database;
    return await db.update('courses', course.toMap(), where: 'id = ?', whereArgs: [course.id]);
  }
}
