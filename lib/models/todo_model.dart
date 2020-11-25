import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/task_model.dart';

class TodoData {
  int id;
  List<TaskData> tasks;
  List<Color> colors;
  String title;
  DateTime createdAt;

  TodoData({
    this.id,
    this.tasks,
    this.colors,
    this.title,
    this.createdAt,
  });


  TodoData copyWith({
    int id,
    List<TaskData> tasks,
    List<Color> colors,
    String title,
    DateTime createdAt,
  }) {
    return TodoData(
      id: id ?? this.id,
      tasks: tasks ?? this.tasks,
      colors: colors ?? this.colors,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tasks': tasks?.map((x) => x?.toMap())?.toList(),
      'colors': jsonEncode(colors?.map((x) => x?.value)?.toList()),
      'title': title,
      'created_at': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory TodoData.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TodoData(
      id: map['id'],
      tasks: List<TaskData>.from((map['tasks'] ?? [])?.map((x) => TaskData.fromMap(x))),
      colors: List<Color>.from(jsonDecode(map['colors'])?.map((x) => Color(x))),
      title: map['title'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(int.tryParse(map['created_at'].toString())),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoData.fromJson(String source) => TodoData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TodoData(id: $id, tasks: $tasks, colors: $colors, title: $title, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is TodoData &&
      o.id == id &&
      listEquals(o.tasks, tasks) &&
      listEquals(o.colors, colors) &&
      o.title == title &&
      o.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      tasks.hashCode ^
      colors.hashCode ^
      title.hashCode ^
      createdAt.hashCode;
  }
}