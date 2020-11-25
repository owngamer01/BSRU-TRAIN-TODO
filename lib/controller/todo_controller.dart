import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/task_database.dart';
import 'package:todo/database/todo_database.dart';
import 'package:todo/enum/alert_enum.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/provider/todo_provider.dart';
import 'package:todo/utils/dialog_utils.dart';

class TodoController {

  TodoController(this._context) : 
    _dialogUtils = DialogUtils(_context);

  TodoDatabase _todoDatabase;
  TaskDatabase _taskDatabase;
  final BuildContext _context;
  final DialogUtils _dialogUtils;

  Future init() async {
    
    _taskDatabase = TaskDatabase();
    _todoDatabase = TodoDatabase(
      taskDatabase: _taskDatabase
    );

    await Future.wait([
      _todoDatabase.onOpen(),
      _taskDatabase.onOpen()
    ]);

    return await getTodo();
  }

  Future<TodoData> addTodo(TodoData data) async {
    var res = await _todoDatabase.addTodo(data);
    if (res.isError) {
      _dialogUtils.show(
        title: res.title,
        content: res.content,
        dialogApp: AlertApp.warning
      );
      return null;
    }
    
    this._context.read<TodoProvider>().addTodo(res.todoData);
    return res.todoData;
  }

  Future<List<TodoData>> getTodo() async {
    final todo = await _todoDatabase.getTodo();
    this._context.read<TodoProvider>().setTodo(todo);
    return todo;
  }

  Future<bool> deleteTodo(TodoData todoData) async {
    final isOk = await _todoDatabase.deleteTodo(todoData);
    if (!isOk) {
      return false;
    }
    this._context.read<TodoProvider>().deleteTodo(todoData);
    return true;
  }

  Future<bool> updateTodo(TodoData todoData, Map<String, dynamic> updateWhere, {
    bool onReload = true
  }) async {
    final res = await _todoDatabase.onUpdateTodo(
      todoData, 
      updateWhere
    );
    if (res.isError) {
      _dialogUtils.show(
        title: res.title,
        content: res.content,
        dialogApp: AlertApp.warning
      );
      return false;
    }
    this._context.read<TodoProvider>().updateTodo(
      todoData,
      onReload
    );
    return true;
  }

  Future<TaskData> addTask(int todoId, TaskData taskData) async {
    final res = await _taskDatabase.onAddTask(taskData);
    if (res.isError) {
      _dialogUtils.show(
        title: res.title,
        content: res.content,
        dialogApp: AlertApp.warning
      );
      return null;
    }
    this._context.read<TodoProvider>().addTask(todoId, taskData);
    return res.taskData;
  }

  Future<bool> updateTask(int todoId, TaskData taskData, Map<String, dynamic> updateWhere, {
    bool onReload = true
  }) async {
    final res = await _taskDatabase.onUpdateTask(
      taskData, 
      updateWhere
    );
    if (res.isError) {
      _dialogUtils.show(
        title: res.title,
        content: res.content,
        dialogApp: AlertApp.warning
      );
      return false;
    }
    this._context.read<TodoProvider>().updateTask(
      todoId, 
      taskData,
      onReload
    );
    return true;
  }

  Future<bool> deleteTask(int todoId, TaskData taskData) async {
    final res = await _taskDatabase.onDeleteTask(taskData);
    if (res.isError) {
      _dialogUtils.show(
        title: res.title,
        content: res.content,
        dialogApp: AlertApp.warning
      );
      return false;
    }
    this._context.read<TodoProvider>().removeTask(todoId, taskData);
    return true;
  }

  void dispose() {
    _todoDatabase.onClose();
    _taskDatabase.onClose();
  }
}