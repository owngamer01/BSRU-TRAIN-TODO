import 'dart:convert';

import 'package:todo/models/task_model.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/models/user_model.dart';

class UserResponse {
  final UserData userData;
  final String title;
  final String context;
  final bool isError;

  UserResponse({
    this.userData,
    this.title,
    this.context,
    this.isError = false,
  });

  UserResponse copyWith({
    UserData userData,
    String title,
    String context,
    bool isError,
  }) {
    return UserResponse(
      userData: userData ?? this.userData,
      title: title ?? this.title,
      context: context ?? this.context,
      isError: isError ?? this.isError,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userData': userData?.toMap(),
      'title': title,
      'context': context,
      'isError': isError,
    };
  }

  factory UserResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserResponse(
      userData: UserData.fromMap(map['userData']),
      title: map['title'],
      context: map['context'],
      isError: map['isError'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserResponse.fromJson(String source) => UserResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserResponse(userData: $userData, title: $title, context: $context, isError: $isError)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserResponse &&
      o.userData == userData &&
      o.title == title &&
      o.context == context &&
      o.isError == isError;
  }

  @override
  int get hashCode {
    return userData.hashCode ^
      title.hashCode ^
      context.hashCode ^
      isError.hashCode;
  }
}

class TodoResponse {
  final TodoData todoData;
  final String title;
  final String content;
  final bool isError;

  TodoResponse({
    this.todoData,
    this.title,
    this.content,
    this.isError = false,
  });

  TodoResponse copyWith({
    TodoData todoData,
    String title,
    String content,
    bool isError,
  }) {
    return TodoResponse(
      todoData: todoData ?? this.todoData,
      title: title ?? this.title,
      content: content ?? this.content,
      isError: isError ?? this.isError,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todoData': todoData?.toMap(),
      'title': title,
      'content': content,
      'isError': isError,
    };
  }

  factory TodoResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TodoResponse(
      todoData: TodoData.fromMap(map['todoData']),
      title: map['title'],
      content: map['content'],
      isError: map['isError'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoResponse.fromJson(String source) => TodoResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TodoResponse(todoData: $todoData, title: $title, content: $content, isError: $isError)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TodoResponse &&
      o.todoData == todoData &&
      o.title == title &&
      o.content == content &&
      o.isError == isError;
  }

  @override
  int get hashCode {
    return todoData.hashCode ^
      title.hashCode ^
      content.hashCode ^
      isError.hashCode;
  }
}


class TaskResponse {
  final TaskData taskData;
  final String title;
  final String content;
  final bool isError;

  TaskResponse({
    this.taskData,
    this.title,
    this.content,
    this.isError = false,
  });

  TaskResponse copyWith({
    TaskData taskData,
    String title,
    String content,
    bool isError,
  }) {
    return TaskResponse(
      taskData: taskData ?? this.taskData,
      title: title ?? this.title,
      content: content ?? this.content,
      isError: isError ?? this.isError,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskData': taskData?.toMap(),
      'title': title,
      'content': content,
      'isError': isError,
    };
  }

  factory TaskResponse.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TaskResponse(
      taskData: TaskData.fromMap(map['taskData']),
      title: map['title'],
      content: map['content'],
      isError: map['isError'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskResponse.fromJson(String source) => TaskResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskResponse(taskData: $taskData, title: $title, content: $content, isError: $isError)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TaskResponse &&
      o.taskData == taskData &&
      o.title == title &&
      o.content == content &&
      o.isError == isError;
  }

  @override
  int get hashCode {
    return taskData.hashCode ^
      title.hashCode ^
      content.hashCode ^
      isError.hashCode;
  }
}
