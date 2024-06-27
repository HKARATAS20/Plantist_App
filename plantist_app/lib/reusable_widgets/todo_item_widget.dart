import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:plantist_app/screens/attachment_view_screen.dart';
import 'package:plantist_app/utils/todo_model.dart';
import 'package:plantist_app/utils/database_manager.dart';

class TodoItemWidget extends StatelessWidget {
  final Todo todo;
  final Function(String) onEdit;
  final Function(String) onDelete;

  TodoItemWidget({
    required this.todo,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    bool hasNotesOrAttachments = todo.notes != "" || todo.fileUrl != null;

    return Slidable(
      key: Key(todo.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(todo.id),
            backgroundColor: CupertinoColors.systemGrey2,
            foregroundColor: Colors.white,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => onDelete(todo.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Delete',
          ),
        ],
      ),
      child: InkWell(
        onTap: hasNotesOrAttachments
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttachmentViewPage(
                      todo: todo,
                    ),
                  ),
                );
              }
            : null,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: GestureDetector(
            onTap: () async {
              await DatabaseManager.updateTodoCompletion(
                  todo.id, !todo.completed);
            },
            child: Icon(
              todo.completed
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: todo.completed ? Colors.green : Colors.grey,
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.completed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: _buildSubtitle(context),
          trailing: _buildTrailing(context),
        ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    List<Widget> subtitleWidgets = [];

    if (todo.fileUrl != null) {
      subtitleWidgets.addAll([
        Row(
          children: [
            Icon(Icons.attach_file, color: Colors.grey, size: 18),
            SizedBox(width: 4),
            Text('1 attachment', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
      ]);
    }

    if (todo.priority != "None") {
      subtitleWidgets.add(
        Text(
          todo.priority,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subtitleWidgets,
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          DateFormat('dd.MM.yyyy').format(todo.date),
          style: const TextStyle(
              color: CupertinoColors.inactiveGray,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        if (todo.time != null)
          Text(
            DateFormat('HH:mm').format(todo.time!),
            style: const TextStyle(
                color: CupertinoColors.systemRed,
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
      ],
    );
  }
}
