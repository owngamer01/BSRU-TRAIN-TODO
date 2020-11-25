import 'dart:convert';

import 'package:flutter/cupertino.dart';

class TaskData {
  int id;
  String name;
  int status;
  int todoId;
  TextEditingController controller;

  TaskData({
    this.id,
    this.name,
    this.status,
    this.todoId,
    this.controller,
  });

  TaskData copyWith({
    int id,
    String name,
    int status,
    int todoId,
    TextEditingController controller,
  }) {
    return TaskData(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      todoId: todoId ?? this.todoId,
      controller: controller ?? this.controller,
    );
  }

  get toggleStatus => status == 0 ? 1 : 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'todo_id': todoId,
      'controller': controller?.text,
    };
  }

  factory TaskData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return TaskData(
      id: map['id'],
      name: map['name'],
      status: map['status'],
      todoId: map['todo_id'],
      controller: null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskData.fromJson(String source) => TaskData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskData(id: $id, name: $name, status: $status, todoId: $todoId, controller: $controller)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TaskData &&
      o.id == id &&
      o.name == name &&
      o.status == status &&
      o.todoId == todoId &&
      o.controller == controller;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      status.hashCode ^
      todoId.hashCode ^
      controller.hashCode;
  }
}
