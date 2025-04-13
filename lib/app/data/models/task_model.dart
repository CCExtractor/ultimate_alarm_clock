import 'dart:convert';

class TaskModel {
  final String id;
  final String text;
  bool completed;

  TaskModel({
    required this.id,
    required this.text,
    this.completed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'completed': completed,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      text: json['text'],
      completed: json['completed'],
    );
  }

  static String encodeTaskList(List<TaskModel> tasks) {
    return jsonEncode(tasks.map((task) => task.toJson()).toList());
  }

  static List<TaskModel> decodeTaskList(String taskListJson) {
    if (taskListJson.isEmpty || taskListJson == '[]') return [];
    final List<dynamic> jsonList = jsonDecode(taskListJson);
    return jsonList.map((json) => TaskModel.fromJson(json)).toList();
  }
} 