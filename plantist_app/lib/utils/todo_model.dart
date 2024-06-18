import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final bool completed;
  final DateTime date;
  final DateTime? time;
  final String priority;
  final String? fileUrl;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.date,
    required this.priority,
    required this.time,
    required this.fileUrl,
  });

  factory Todo.fromMap(Map<String, dynamic> data, String id) {
    return Todo(
      id: id,
      title: data['title'] ?? '',
      completed: data['completed'] ?? false,
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] != null ? (data['time'] as Timestamp).toDate() : null,
      priority: data['priority'] ?? 'Normal',
      fileUrl: data['fileUrl'] ?? null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
      'date': Timestamp.fromDate(date),
      'time': time != null ? Timestamp.fromDate(time!) : null,
      'priority': priority,
      'fileUrl': fileUrl,
    };
  }
}
