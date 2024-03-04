import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  Database? _db;

  initDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "todoDb.db");
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  void onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Task(taskName TEXT , taskDate TEXT,taskStatus TEXT)');
  }

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDB();
      return _db;
    } else {
      return _db;
    }
  }

  Future<int> createTask(Task task) async {
    var dbReady = await db;
    return await dbReady!.rawInsert(
        "INSERT INTO Task(taskName,taskDate,taskStatus) VALUES('${task.taskName}','${task.taskDate}','${task.taskStatus}')");
  }

  Future<int> updateTask(Task task) async {
    var dbReady = await db;
    return await dbReady!.rawUpdate(
        "UPDATE Task SET taskStatus = '${task.taskStatus}' WHERE taskName = '${task.taskName}'");
  }

  Future<int> deleteTask(String taskName) async {
    var dbReady = await db;
    return await dbReady!
        .rawDelete("DELETE FROM Task WHERE taskName = '$taskName'");
  }

  Future<Task> readTask(String taskName) async {
    var dbReady = await db;
    var read = await dbReady!
        .rawQuery("SELECT * FROM Task WHERE taskName = '$taskName'");
    return Task.fromMap(read[0]);
  }

  Future<List<Task>> readAllTask() async {
    var dbReady = await db;
    List<Map> list = await dbReady!.rawQuery("SELECT * FROM Task ORDER BY taskDate ASC");
    List<Task>? task = [];
    for (int i = 0; i < list.length; i++) {
      task.add(Task(
        list[i]["taskName"],
        list[i]["taskDate"],
        list[i]["taskStatus"],
      ));
    }
    return task;
  }
}
