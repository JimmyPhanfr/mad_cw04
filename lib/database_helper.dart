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

  // static const _databaseName = "MyDatabase.db";
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

  // this opens the database (and creates it if it doesn't exist)
  // Future<void> init() async { 
  //   final documentsDirectory = await getApplicationDocumentsDirectory();
  //   final path = join(documentsDirectory.path, _databaseName);
  //   _db = await openDatabase(
  //     path,
  //     version: _databaseVersion,
  //     onCreate: _onCreate,
  //   );
  // }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnStatus TEXT NOT NULL,
      $columnDetails TEXT,
      $columnDate TEXT,
      $columnList TEXT
    )''');
  }

  // Helper methods
  // Inserts a row in the database where each key in the
  // Map is a column name
  // and the value is the column value. The return value
  // is the id of the inserted row.
  // Future<int> insert(Map<String, dynamic> row) async {
  //   return await _db.insert(table, row);
  // }

  // // All of the rows are returned as a list of maps, where each map is
  // // a key-value list of columns.
  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   return await _db.query(table);
  // }

  // // All of the methods (insert, query, update, delete) can also be done using
  // // raw SQL commands. This method uses a raw query to give the row count.
  // Future<int> queryRowCount() async {
  //   final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
  //   return Sqflite.firstIntValue(results) ?? 0;
  // }

  // // We are assuming here that the id column in the map is set. The other
  // // column values will be used to update the row.
  // Future<int> update(Map<String, dynamic> row) async {
  //   int id = row[columnId];
  //   return await _db.update(
  //     table,
  //     row,
  //     where: '$columnId = ?',
  //     whereArgs: [id],
  //   );
  // }

  // // Deletes the row specified by the id. The number of affected rows is
  // // returned. This should be 1 as long as the row exists.
  // Future<int> delete(int id) async {
  //   return await _db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Future<List<Map<String, dynamic>>> query(int id) async {
  //   return await _db.query(table, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Future<int> deleteAllRecords() async {
  //   return await _db.delete(table);
  // }

  void addTask(String name, String status, String details, String date) async {
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
      status: e["status"] as String,
      details: e["details"] as String,
      date: e["date"] as String,
      list: e["list"] as String,
    ),).toList();
    return tasks;
  }
}
