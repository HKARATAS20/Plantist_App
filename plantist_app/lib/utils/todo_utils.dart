import 'package:intl/intl.dart';
import 'todo_model.dart';

Map<String, List<Todo>> groupTodosByDate(List<Todo> todos) {
  final Map<String, List<Todo>> groupedTodos = {
    'Today': [],
    'Tomorrow': [],
    'Others': [],
  };

  final today = DateTime.now();
  final tomorrow = today.add(Duration(days: 1));

  for (final todo in todos) {
    final todoDate = DateTime(todo.date.year, todo.date.month, todo.date.day);

    if (todoDate == DateTime(today.year, today.month, today.day)) {
      groupedTodos['Today']!.add(todo);
    } else if (todoDate ==
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day)) {
      groupedTodos['Tomorrow']!.add(todo);
    } else {
      groupedTodos['Others']!.add(todo);
    }
  }

  for (var key in groupedTodos.keys) {
    groupedTodos[key]!.sort((a, b) => _comparePriority(a.priority, b.priority));
  }

  return groupedTodos;
}

int _comparePriority(String? a, String? b) {
  const priorityOrder = {'High': 1, 'Normal': 2, 'Low': 3, 'None': 4};
  a ??= 'None';
  b ??= 'None';
  return priorityOrder[a]!.compareTo(priorityOrder[b]!);
}
