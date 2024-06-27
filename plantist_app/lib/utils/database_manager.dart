import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:plantist_app/utils/notification_service.dart';
import 'todo_model.dart';
import 'package:uuid/uuid.dart';

class DatabaseManager {
  static final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  static final User? _currentUser = FirebaseAuth.instance.currentUser;

  static Future<String> addTodo(String title, String notes, bool completed,
      DateTime date, DateTime? time, String priority) async {
    try {
      final uuid = Uuid();
      DocumentReference docRef = await _todosCollection.add({
        'title': title,
        'notes': notes,
        'completed': completed,
        'date': Timestamp.fromDate(date),
        'time': time != null ? Timestamp.fromDate(time) : null,
        'priority': priority,
        'userId': _currentUser!.uid,
      });

      if (time != null) {
        DateTime scheduleTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        DateTime now = DateTime.now();

        // Notification 24 hours before the scheduled time
        DateTime twentyFourHoursBefore =
            scheduleTime.subtract(const Duration(hours: 24));
        if (twentyFourHoursBefore.isAfter(now)) {
          NotificationService().scheduleNotification(
              id: uuid.v4().hashCode,
              title: 'Reminder: 24 hours to go!',
              body: title,
              scheduledNotificationDateTime: twentyFourHoursBefore);
          print("scheduled for $twentyFourHoursBefore");
        }

        // Notification 5 minutes before the scheduled time
        DateTime fiveMinutesBefore =
            scheduleTime.subtract(const Duration(minutes: 5));
        if (fiveMinutesBefore.isAfter(now)) {
          NotificationService().scheduleNotification(
              id: uuid.v4().hashCode,
              title: 'Reminder: 5 minutes to go!',
              body: title,
              scheduledNotificationDateTime: fiveMinutesBefore);
          print("scheduled for $fiveMinutesBefore");
        }
      }
      return docRef.id;
    } catch (e) {
      print('Error adding todo: $e');
      return '';
    }
  }

  static Future<void> updateTodoFileUrl(String todoId, String fileUrl) async {
    try {
      await _todosCollection.doc(todoId).update({
        'fileUrl': fileUrl,
      });
      print('Todo file URL updated successfully');
    } catch (e) {
      print('Error updating todo file URL: $e');
    }
  }

  static Future<void> deleteTodo(String todoId) async {
    try {
      await _todosCollection.doc(todoId).delete();
      print('Todo deleted successfully');
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  static Future<List<Todo>> getTodos() async {
    try {
      QuerySnapshot querySnapshot = await _todosCollection
          .where('userId', isEqualTo: _currentUser!.uid)
          .get();
      return querySnapshot.docs
          .map(
              (doc) => Todo.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching todos: $e');
      return [];
    }
  }

  static Stream<List<Todo>> todosStream() {
    return _todosCollection
        .where('userId', isEqualTo: _currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Todo.fromMap(data, doc.id);
      }).toList();
    });
  }

  static Future<void> updateTodoTitle(String todoId, String newTitle) async {
    try {
      await _todosCollection.doc(todoId).update({
        'title': newTitle,
      });
      print('Todo title updated successfully');
    } catch (e) {
      print('Error updating todo title: $e');
    }
  }

  static Future<void> updateTodoCompletion(
      String todoId, bool completed) async {
    try {
      await _todosCollection.doc(todoId).update({
        'completed': completed,
      });
      print('Todo completion status updated successfully');
    } catch (e) {
      print('Error updating todo completion status: $e');
    }
  }
}
