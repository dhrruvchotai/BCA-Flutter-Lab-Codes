import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CrudDatabaseHelper {
  late Database? _db;

  // Initialize DB
  Future<void> initDB() async {
    String path = join(await getDatabasesPath(), "student.db");
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Student(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            gender TEXT,
            hobbies TEXT
          )
        ''');
      },
    );
  }

  // Insert
  Future<int> insertStudent(Map<String, dynamic> row) async {
    return await _db!.insert("Student", row);
  }

  // Read all
  Future<List<Map<String, dynamic>>> getStudents() async {
    return await _db!.query("Student");
  }

  // Delete
  Future<int> deleteStudent(int id) async {
    return await _db!.delete("Student", where: "id = ?", whereArgs: [id]);
  }

  // Update
  Future<int> updateStudent(int id, Map<String, dynamic> row) async {
    return await _db!.update("Student", row, where: "id = ?", whereArgs: [id]);
  }
}
