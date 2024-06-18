import 'package:flutter/material.dart';
import 'package:plantist_app/utils/database_manager.dart';

Future<void> showEditDialog(
    BuildContext context, String todoId, String currentTitle) async {
  TextEditingController titleController =
      TextEditingController(text: currentTitle);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Todo'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Enter your task'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty) {
                await DatabaseManager.updateTodoTitle(todoId, newTitle);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
