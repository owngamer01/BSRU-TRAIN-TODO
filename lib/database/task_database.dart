import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo/interface/database_interface.dart';
import 'package:path/path.dart';
import 'package:todo/models/response_model.dart';
import 'package:todo/models/task_model.dart';

final String taskTable     = 'task_table';

final String colId         = 'id';
final String colTodoId     = 'todo_id';
final String colName       = 'name';
final String colStatus     = 'status';

class TaskDatabase extends DatabaseInterface {

  final _dbname  = 'task.db';
  final _version = 1;

  Database _db;

  @override
  Future<Database> onOpen() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbname);

    _db = await openDatabase(path, version: _version, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $taskTable ( 
          $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $colTodoId INT NOT NULL,
          $colName TEXT NOT NULL,
          $colStatus INT NOT NULL
        )
      ''');
    });

    return _db;
  }

  @override
  Future onClose() async {
    return _db?.close();
  }

  get _databaseCatch => TaskResponse(
    isError: true,
    title: 'DB Catch',
    content: 'Unavaliable try again later.'
  );

  Future<TaskResponse> onAddTask(TaskData task) async {
    try {
      var _task = task.toMap();
      _task.remove('controller');

      task.id = await _db.insert(taskTable, _task);
      return TaskResponse(taskData: task);
    } catch (e) {
      return _databaseCatch;
    }
  }

  Future<TaskResponse> onDeleteTask(TaskData task) async {
    try {
      var count = await _db.delete(taskTable, 
        where: '$colId = ?',
        whereArgs: [task.id]
      );
      return count == 1 
        ? TaskResponse(title: 'success') 
        : TaskResponse(title: 'Can\'t find this record', isError: true);
    } catch (e) {
      return _databaseCatch;
    }
  }

  Future<TaskResponse> onUpdateTask(TaskData task, Map<String, dynamic> updateWhere) async {
    try {
      var count = await _db.update(taskTable, updateWhere,
        where: '$colId = ?',
        whereArgs: [task.id]
      );
      return count == 1 
        ? TaskResponse(title: 'success') 
        : TaskResponse(title: 'Can\'t update this record', isError: true);
    } catch (e) {
      return _databaseCatch;
    }
  }

  Future<List<TaskData>> getTasksByTodoId(int todoId) async {
    final tasks = await _db.query(taskTable, 
      where: '$colTodoId = ?',
      whereArgs: [todoId]
    );
    return tasks.map((item) => TaskData.fromMap(item)).toList();
  }
}