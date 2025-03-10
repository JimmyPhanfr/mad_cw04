import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'task.dart';

class DatabaseHelper {
  static Database? _db;
  static final DatabaseHelper instance = DatabaseHelper._constructor(); 
  DatabaseHelper._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  static const _databaseVersion = 1;

  static const table = 'plans_table';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnStatus = 'status';
  static const columnDetails = 'details';
  static const columnDate = 'date';
  static const columnList = 'list';

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "main_db.db"); 
    final database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
    return database;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnStatus INT NOT NULL,
      $columnDetails TEXT,
      $columnDate TEXT,
      $columnList TEXT
    )''');
  }

  // Helper methods
  void addTask(String name, int status, String details, String date) async {
    final db = await database;
    await db.insert(
      table, 
      {
        columnName: name,
        columnStatus: status,
        columnDetails: details,
        columnDate: date,
        columnList: "",
      }
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final data = await db.query(table);
    List<Task> tasks = data.map((e) => Task(
      id: e["id"] as int, 
      name: e["name"] as String, 
      status: e["status"] as int,
      details: e["details"] as String,
      date: e["date"] as String,
      list: e["list"] as String,
    ),).toList();
    return tasks;
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
      table, 
      {
        columnStatus: status,
      },
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }

  void updateTask(int id, String name, int status, String details, String date) async {
    final db = await database;
    await db.update(
      table, 
      {
        columnName: name,
        columnStatus: status,
        columnDetails: details,
        columnDate: date,
      },
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }
}
