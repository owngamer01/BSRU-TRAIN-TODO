import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:todo/interface/database_interface.dart';
import 'package:path/path.dart';
import 'package:todo/models/response_model.dart';
import 'package:todo/models/todo_model.dart';

final String todoTable     = 'todo_table';

final String colId         = 'id';
final String colTitle      = 'title';
final String colColor      = 'colors';
final String colCreatedAt  = 'created_at';

class TodoDatabase extends DatabaseInterface {

  TodoDatabase({
    @required this.taskDatabase
  });

  final taskDatabase;
  final _dbname  = 'todo.db';
  final _version = 1;

  Database _db;

  @override
  Future<Database> onOpen() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbname);

    _db = await openDatabase(path, version: _version, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $todoTable ( 
          $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $colTitle TEXT NOT NULL,
          $colColor TEXT NOT NULL,
          $colCreatedAt TEXT NOT NULL
        )
      ''');
    });

    return _db;
  }

  @override
  Future onClose() async {
    return _db?.close();
  }
  
  get _databaseCatch => TodoResponse(
    isError: true,
    title: 'DB Catch',
    content: 'Unavaliable try again later.'
  );

  Future<TodoResponse> addTodo(TodoData todo) async {
    try {

      var _todoMap = todo.toMap()
        ..remove('id')
        ..remove('tasks');

      todo.id = await _db.insert(todoTable, _todoMap);
      return TodoResponse(todoData: todo);
    } catch (e) {
      return _databaseCatch;
    }
  }
  
  Future<List<TodoData>> getTodo() async {
    try {
      
      final mapTodo = await _db.query(todoTable);

      var map = mapTodo.map((item) 
        => TodoData.fromMap(item)).toList();

      if (map.length <= 0) return [];

      for (var item in map) {
        item.tasks = await taskDatabase.getTasksByTodoId(item.id);
      }

      return map;

    } catch (e) {
      return [];
    }
  }

  Future<TaskResponse> onUpdateTodo(TodoData todo, Map<String, dynamic> updateWhere) async {
    try {
      var count = await _db.update(todoTable, updateWhere,
        where: '$colId = ?',
        whereArgs: [todo.id]
      );
      return count == 1 
        ? TaskResponse(title: 'success') 
        : TaskResponse(title: 'Can\'t update this record', isError: true);
    } catch (e) {
      return _databaseCatch;
    }
  }

  Future<bool> deleteTodo(TodoData todoData) async {
    int indexCount = await _db.delete(todoTable, 
      where: '$colId = ?', 
      whereArgs: [todoData.id]
    );
    return indexCount == 1 ? true : false;
  }
}