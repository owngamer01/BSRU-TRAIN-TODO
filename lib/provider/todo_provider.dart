import 'package:flutter/foundation.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  
  List<TodoData> get todo => _todo;
  List<TodoData> _todo = [];

  void reload() {
    notifyListeners();
  }

  void setTodo(List<TodoData> todoData) {
    _todo = todoData;
    notifyListeners();
  }

  void addTodo(TodoData todoData) {
    _todo.add(todoData);
    notifyListeners();
  }

  void deleteTodo(TodoData todoData) {
    _todo.removeWhere((item) => item.id == todoData.id);
    notifyListeners();
  }

  void updateTodo(TodoData todoData, [bool onReload]) {
    var index = _todo.indexWhere((todo) => todo.id == todoData.id);
    _todo[index] = todoData;
    
    if (onReload) {
      notifyListeners();
    }
  }

  TodoData getTodo(TodoData todoData) {
    return _todo.firstWhere((item) => item.id == todoData.id, orElse: () => null);
  }

  void addTask(int todoId, TaskData taskData) {
    var todo = _todo.firstWhere((todo) => todo.id == todoId);
    todo.tasks.add(taskData);
    notifyListeners();
  }

  void updateTask(int todoId, TaskData taskData, [bool onReload]) {
    var todo = _todo.firstWhere((todo) => todo.id == todoId);
    var index = todo.tasks.indexWhere((item) => item.id == taskData.id);

    todo.tasks[index] = taskData;
    if (onReload) {
      notifyListeners();
    }
  }

  void removeTask(int todoId, TaskData taskData) {
    var todo = _todo.firstWhere((todo) => todo.id == todoId);
    todo.tasks.removeWhere((task) => task.id == taskData.id);
    notifyListeners();
  }
}